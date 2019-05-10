import pandas as pd
import sys
import os

# Author: Nicolas Matentzoglu
# Date: 21.11.2018
# Samples, Phenotypes and Ontologies Team, EMBL-EBI

comparison = sys.argv[1]
file = sys.argv[2]

c1 = comparison.split("/")[0]
c2 = comparison.split("/")[1]

df_c1 = pd.read_csv(os.path.join(c1,file), sep='\t')
df_c2 = pd.read_csv(os.path.join(c2,file), sep='\t')

print(df_c1.iloc[:,[0,1,2]].head())
print(df_c2.iloc[:,[0,1,2]].head())