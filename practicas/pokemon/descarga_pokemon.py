import os
import shutil
from multiprocessing import Pool

import argparse
import gspread
import numpy as np
import pandas as pd
import requests
from glom import glom
from oauth2client.service_account import ServiceAccountCredentials


def make_pool(func, params, threads):
    """
    Ejecuta de forma simultánea múltiples llamadas a una función
    :param func: function, objeto función a paralelizar
    :param params: iterable, parámetros de evaluación paralela
    :param threads: int, número de hilos de multiprocesamiento
    :return: list, resultado de la ejecución paralela agrupada en una lista
    """
    pool = Pool(threads)
    data = pool.starmap(func, params)
    pool.close()
    pool.join()
    del pool
    return [x for x in data]

def crear_carpeta_en_datos(numero:int):
    """ Crea una carpeta en la carpeta datos con el nombre del numero que se le pasa como parametro.

    Args:
        numero (int): Numero de la carpeta a crear
    """
    # Directorio base
    directorio_base = "datos"
    
    # Ruta completa de la carpeta a crear
    nueva_carpeta = os.path.join(directorio_base, f"{numero:03d}")
    
    try:
        # Si la carpeta ya existe, la borramos completamente
        if os.path.exists(nueva_carpeta):
            shutil.rmtree(nueva_carpeta)
        
        # Creamos la carpeta nuevamente
        os.makedirs(nueva_carpeta)
    except Exception as e:
        print(f"Error al crear la carpeta: {e}")

def obtener_datos_pokemon(id: int) -> pd.DataFrame:
    url = f"https://pokeapi.co/api/v2/pokemon/{id}"
    req = requests.get(url)
    datos = {}
    if req.status_code == 200:
        payload = req.json()
        # Extracción de claves directas
        claves = ['base_experience',
                  'height',
                  'name',
                  'sprites.other.official-artwork.front_default']
        datos.update(
            dict(zip(claves, map(lambda x: glom(payload, x), claves))))
        datos["image"] = datos.pop(
            "sprites.other.official-artwork.front_default")
        # Extracción de stats
        stats = glom(payload, 'stats')

        def getStat(stat):
            return (glom(stat, 'stat.name'), glom(stat, 'base_stat'))
        stats = dict(map(getStat, stats))
        datos.update(stats)
        datos = pd.Series(datos).to_frame().T
        datos.insert(0,'id',id)
        return datos
    else:
        return {}
    
def descargar_imagen(url:str, ruta_guardado:str):
    try:
        # Realizar la solicitud HTTP para obtener el contenido de la imagen
        respuesta = requests.get(url)
        
        # Extraer el nombre del archivo de la URL
        nombre_archivo = os.path.basename(url)

        # Construir la ruta completa para guardar la imagen
        ruta_completa = os.path.join(ruta_guardado, nombre_archivo)

        # Guardar el contenido de la imagen en un archivo local
        with open(ruta_completa, "wb") as archivo_local:
            archivo_local.write(respuesta.content)
    except requests.exceptions.RequestException as e:
        print(f"Error al descargar la imagen: {e}")

def flujo_completo(id:int):
    try:
        crear_carpeta_en_datos(id)
        datos = obtener_datos_pokemon(id)
        url_imagen = datos['image'].values[0]
        descargar_imagen(url_imagen, f"datos/{id:03d}")
        datos.to_parquet(f"datos/{id:03d}/{id:03d}.parquet")
        return True
    except Exception as e:
        print(f"Error al obtener los datos del pokemon: {e}")
        return False

def carga_spreadsheets(datos:pd.DataFrame,creds:str):
    """ Carga los datos en la hoja de calculo de google

    Args:
        datos (pd.DataFrame): Datos a cargar
        creds (str): Credenciales de acceso a la hoja de calculo
    """
    credentials = ServiceAccountCredentials.from_json_keyfile_name(creds, 
    ['https://www.googleapis.com/auth/spreadsheets', 'https://www.googleapis.com/auth/drive'])

    client = gspread.authorize(credentials)
    spreadsheet = client.open_by_key('1kNwp2JzT12s8-AmZx0FWaM5cMoAPILhrtgmzFKoGxjE')
    worksheet = spreadsheet.get_worksheet(0)  
    worksheet.update([datos.columns.tolist()] + datos.values.tolist())


if __name__ == '__main__':
    parser = argparse.ArgumentParser()
    parser.add_argument("creds", type=str, help="Ruta con credenciales")
    args = parser.parse_args()
    print("Extrayendo datos de pokemon al disco")
    make_pool(flujo_completo, [(i,) for i in range(1, 900)], 100)
    print("Consolidando datos de pokemon")
    datos = pd.concat(make_pool(obtener_datos_pokemon, [(i,) for i in range(1, 900)], 100),ignore_index=True)
    print("Cargo datos a la hoja de calculo")
    carga_spreadsheets(datos,args.creds )
    print("Gotta catch 'em all!")




