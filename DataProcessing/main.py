import requests
import json
import csv


def load_config():

    with open('./config.json', 'r', encoding='utf8') as f:
        config = json.load(f)
    return config


def search_geocode(config, query):

    params = {
        'query': query,
    }
    headers = {
        'X-NCP-APIGW-API-KEY-ID': config['NAVER_MAP_API']['X-NCP-APIGW-API-KEY-ID'],
        'X-NCP-APIGW-API-KEY': config['NAVER_MAP_API']['X-NCP-APIGW-API-KEY']
    }
    r = requests.get(
        'https://naveropenapi.apigw.ntruss.com/map-geocode/v2/geocode', params=params, headers=headers)

    return r.json()


def read_csv(filepath):

    rows = []

    with open(filepath) as csvfile:
        csv_reader = csv.reader(csvfile)
        for row in csv_reader:
            rows.append(row)

    return rows


def write_csv(filepath, header, data):

    with open(filepath, 'w', encoding='utf8', newline='') as f:
        writer = csv.writer(f)

        writer.writerow(header)
        writer.writerows(data)


def main():
    config = load_config()
    rows = read_csv('./trashcanlist.csv')
    new_rows = []
    found, tot = 0, 0
    addresses = []
    for row in rows[1:]:
        print(row)
        dist = row[1].replace('\n', ' ')
        location = row[3].replace('\n', ' ')
        query = f'서울 {dist} {location}'

        res = search_geocode(config, query)

        tot += 1
        address = None
        if len(res['addresses']) > 0:
            found += 1
            address = {
                'roadAddress': res['addresses'][0]['roadAddress'],
                'jibunAddress': res['addresses'][0]['jibunAddress'],
                'englishAddress': res['addresses'][0]['englishAddress'],
                'x': res['addresses'][0]['x'],
                'y': res['addresses'][0]['y'],
            }

        addresses.append(address)

        new_rows.append([*row, '' if address is None else address['roadAddress'], '' if address is None else address['jibunAddress'],
                         '' if address is None else address['englishAddress'], '' if address is None else address['x'], '' if address is None else address['y']])

    print(found, tot, found / tot * 100)

    write_csv('preprocessed_trashcanlist.csv', [
              *rows[0], '도로명', '지번', '영문', 'x', 'y'], new_rows)


if __name__ == '__main__':
    main()
