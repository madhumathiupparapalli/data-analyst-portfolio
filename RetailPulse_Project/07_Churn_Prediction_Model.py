import pandas as pd
Churn_Prediction_Model = pd.read_csv(r'C:\Users\Madhumathi\Desktop\RetailPulse\01_Data\Cleaned_Data\Cleaned_Data.csv',usecols=['user_id','order_number','days_since_prior_order','reordered','add_to_cart_order'],dtype={
        'user_id': 'int32',
        'order_number': 'int16',
        'days_since_prior_order': 'float32',
        'reordered': 'int8',
        'add_to_cart_order': 'int16'
    },

    nrows=500000
)
print(Churn_Prediction_Model.shape)
print(Churn_Prediction_Model.head())
print(Churn_Prediction_Model.columns)
print("Maximum Days:",Churn_Prediction_Model['days_since_prior_order'].max())

Churn_Prediction_Model['churn_label'] = (Churn_Prediction_Model['days_since_prior_order'] > 10).astype(int)
print(Churn_Prediction_Model['churn_label'].value_counts())
print(Churn_Prediction_Model[['days_since_prior_order', 'churn_label']].head())

X = Churn_Prediction_Model[
    [
        'order_number',
        'days_since_prior_order',
        'reordered',
        'add_to_cart_order'
    ]
]
y = Churn_Prediction_Model['churn_label']

from sklearn.model_selection import train_test_split

X_train, X_test, y_train, y_test = train_test_split(
    X,
    y,
    test_size=0.2,
    random_state=42
)

from sklearn.linear_model import LogisticRegression

model = LogisticRegression()

model.fit(X_train, y_train)

y_pred = model.predict(X_test)

from sklearn.metrics import accuracy_score

accuracy = accuracy_score(y_test, y_pred)

print("Model Accuracy:", accuracy)

from sklearn.metrics import confusion_matrix

cm = confusion_matrix(y_test, y_pred)

print(cm)

import seaborn as sns
import matplotlib.pyplot as plt

plt.figure(figsize=(6,4))

sns.heatmap(cm,annot=True,fmt='d',cmap='Blues')

plt.title('Confusion Matrix')
plt.xlabel('Predicted')
plt.ylabel('Actual')

plt.show()

feature_importance = pd.Series(model.coef_[0],index=X.columns)
feature_importance.abs().sort_values(ascending=False).plot(kind='bar')
plt.show()

Churn_Prediction_Model['predicted_churn'] = model.predict(X)

Churn_Prediction_Model.to_csv(r'C:\Users\Madhumathi\Desktop\RetailPulse\03_Python\Churn_Prediction_Output.csv',index=False)