import pandas as pd

df = pd.read_excel (r'C:/Users/marti/Desktop/CIU/Practica5_Iluminacion_texturas/SÍTYCLETA-2021.xlsx')



# 10 zonas con más alquileres de bicicletas realizados
#uniqueValues = df['Rental place'].value_counts().head(10)
#print(uniqueValues)

# San Telmo                11291
# Plaza de la feria         9617
# Base Naval                9612
# Parque Santa Catalina     9411
# Plazoleta de Farray       8817
# Plaza O'Shanahan          8464
# León y Castillo           8030
# Plaza de España           7551
# Plaza del Pilar           7161
# Torre Woermann            6702


# Mantener solo filas que tienen estas zonas como lugar de alquiler

df= df[(df['Rental place']=='San Telmo') | (df['Rental place']=='Plaza de la feria') | (df['Rental place']=='Base Naval') | (df['Rental place']=='Parque Santa Catalina') | (df['Rental place']=='Plazoleta de Farray')  | (df['Rental place']=='Plaza O\'Shanahan') | (df['Rental place']=='León y Castillo') | (df['Rental place']=='Plaza de España') | (df['Rental place']=='Plaza del Pilar') | (df['Rental place']=='Torre Woermann') ]


writer = pd.ExcelWriter('Sitycleta21-clean.xlsx')
# write dataframe to excel
df.to_excel(writer)
# save the excel
writer.save()