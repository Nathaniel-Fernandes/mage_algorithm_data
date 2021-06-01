import os
import pandas as pd
from cgmquantify import MAGE, MGE
import re

columns = ["num", "name", "mage"]
output_df = pd.DataFrame(columns=columns)
#print(output_df)

print(os.listdir(os.getcwd()))
# change the current working directory to "graphics_scripts/external algorithms/data/files"
for filename in os.listdir(os.getcwd()):
    print(filename, end=" ")
    # read in csv file
    df = pd.read_csv(filename)

    data = pd.DataFrame(df)

    # format time, day, gl
    data['Time'] = df['timestamp'] 
    data['Time'] = pd.to_datetime(data['Time'], format='%Y-%m-%dT%H:%M')

    data['Day'] = data['Time'].dt.date

    data['Glucose'] = pd.to_numeric(df['sensorglucose'])

    mage_data = MAGE(data)

    num = int(re.findall('[0-9]+', filename)[0])

    output_df.loc[len(output_df)] = [num, filename,mage_data]

print(output_df)
output_df.sort_values(by=['num'], inplace=True)
output_df.to_csv(os.getcwd() + "/../cgmquantify_output.csv", index=False)
