import requests
import json

# GraphQLエンドポイントURL適切に置き換える
# url = "https://indexer.bigdevenergy.link/XXXXX/v1/graphql"
url = "http://localhost:8080"

# 送信するGraphQLクエリ
query = """
query MyQuery {
  User {
    greetings
  }
}
"""

# GraphQLエンドポイントに対するリクエストヘッダー
headers = {
    "Content-Type": "application/json",
}

# リクエストデータ
data = {"query": query}

# POSTリクエストを送信してレスポンスを取得
response = requests.post(url, json=data, headers=headers)

# レスポンスデータを整形して表示
# json.dumps()の第二引数にindentを指定することで整形できる
# sort_keys=Trueはキーをアルファベット順にソートするオプション
formatted_response = json.dumps(response.json(), indent=4, sort_keys=True)
print(formatted_response)
