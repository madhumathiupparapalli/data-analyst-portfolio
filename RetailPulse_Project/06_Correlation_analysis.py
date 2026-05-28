import pandas as pd
Correlation_analysis = pd.read_csv(r'C:\Users\Madhumathi\Desktop\RetailPulse\01_Data\Cleaned_Data\Cleaned_Data.csv',usecols=['order_number','days_since_prior_order','reordered','add_to_cart_order'])

Correlation_matrix = Correlation_analysis.corr()
print(Correlation_matrix)

import seaborn as sns
import matplotlib.pyplot as plt
plt.figure(figsize=(8,6))
sns.heatmap(Correlation_matrix,annot=True,cmap='coolwarm')
plt.title('Correlation Analysis')
plt.show()
Correlation_matrix.to_csv(r'C:\Users\Madhumathi\Desktop\RetailPulse\03_Python\Correlation_matrix.csv')