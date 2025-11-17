"""File contentente le funzioni utili all'elaborazione dei dati per la dashboard su Tableau"""

import pandas as pd

dict_age_classes = {'0-13': [0 , 13],
                    '14-17': [14, 17],
                    '18-24': [18, 24],
                    '25-34': [25, 34],
                    '35-44': [35, 44],
                    '45-54': [45, 54],
                    '55-64': [55, 64],
                    '65 e oltre':[65, 130]}

def age_clustering(eta):
    """Funzione di clusterizzazione in classi di età seguendo la suddivisione dei dati disponibili
    0-13
    14-17
    18-24
    25-34
    35-44
    45-54
    55-64
    65 e oltre
    """
    for label, (start, end) in dict_age_classes.items():
        if eta == "":
            return "non definito"
        elif eta == "100 e oltre":
            return "65 e oltre"
        elif start <= int(eta) <= end:
            return label
        
def age_sort(classe_eta):
    """
    Restituisce l'indice numerico della classe di età per ordinamento.
    Se la classe non è riconosciuta, restituisce 99.
    """
    age_classes = list(dict_age_classes.keys())
    if classe_eta in age_classes:
        return age_classes.index(classe_eta)
    else:
        return 99  # Classe non definita
