import pandas as pd

data = pd.read_csv('../data/smart_meter_clean.csv', parse_dates=['date_time'], infer_datetime_format=True, sep=" ")
COLS = ['energy', 'date_time']
data.index = pd.to_datetime(data.date_time)
data['hour'] = data.index.hour
data['weekday'] = data.index.weekday
del data['date_time']

data.to_csv('../data/smart_meter.csv', index=False)
