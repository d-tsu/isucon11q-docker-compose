# memo
## TODO
- 動作確認等でetcが汚れているので、後で差し替える。
- 1_InitData.sql が gitignore されていたようなので、どこかから持ってくる。。

## 環境構築
```
sudo docker-compose up
```

## アプリの起動
```
sudo docker-compose exec app bash

# パターン１：起動だけ
~/isucon/start.sh

# パターン２：起動と /initialize リクエスト
~/isucon/start-and-init.sh
```

## 環境削除
```
sudo docker-compose down
```