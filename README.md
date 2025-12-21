[![Rails Tests and Lint](https://github.com/php8-study/php8-study-app/actions/workflows/ci.yml/badge.svg)](https://github.com/php8-study/php8-study-app/actions/workflows/ci.yml)
[![Deploy](https://github.com/php8-study/php8-study-app/actions/workflows/deploy.yml/badge.svg)](https://github.com/php8-study/php8-study-app/actions/workflows/deploy.yml)
![Ruby](https://img.shields.io/badge/ruby-3.4.7-CC342D.svg?logo=ruby&style=flat)
![Rails](https://img.shields.io/badge/rails-8.1.1-CC0000.svg?logo=rubyonrails&style=flat)
![SQlite](https://img.shields.io/badge/sqlite-3.51-003B57.svg?logo=sqlite&style=flat)
![TailwindCSS](https://img.shields.io/badge/tailwindcss-4.1-38B2AC.svg?logo=tailwind-css&style=flat)
![Hotwire](https://img.shields.io/badge/hotwire-turbo%20%26%20stimulus-yellow.svg?style=flat)
![Kamal](https://img.shields.io/badge/deploy-kamal-blue.svg?style=flat)

# PHP8技術者認定初級試験スタディ
<img width="1594" height="713" alt="image" src="https://github.com/user-attachments/assets/c46767fe-960d-4368-b734-86d2a1b0ebed" />


## 概要
PHP8技術者認定初級試験スタディはPHP8技術者認定初級試験を受験する人に向けた、学習サポートアプリです。

## 特徴
PHP8技術者認定初級試験の公式認定教材である 独習PHP 第4版 の解説内容を参考に200問以上の問題を学習することが出来ます。

* **ランダム演習**: 全問題からランダムに出題され、手軽に学習できます。
* **模擬試験**: 実際の試験と同じ配分・問題数で出題されます。
* **成績管理**: 模擬試験の受験結果や履歴を記録・管理できます。
* **管理機能**: 管理者は問題・カテゴリーを作成、変更、削除することができます。

※ 本アプリは非公式ツールです。

## URL
https://php8-study.jp

## デモ

### ランダム問題
https://github.com/user-attachments/assets/1b05f476-4551-42c1-b7f9-85b920c3c249

### 模擬試験
https://github.com/user-attachments/assets/2051db71-0492-4c33-b9a7-061a5f78372e

### 管理者画面
https://github.com/user-attachments/assets/9986f016-1afd-4219-b778-0e33c8a8ce4a

## 環境構築
以下の手順でローカル環境を構築できます。

1. リポジトリのクローンとセットアップ
```bash
$ git clone https://github.com/php8-study/php8-study-app.git
$ cd php8_study
$ bin/setup
```

2. 環境変数の設定(GitHub OAuth)
本番環境では GitHub OAuth を使用してログインを行います。
`.env` ファイルを作成し、GitHub Developer Settings で取得した以下のキーを設定してください。
```bash
GITHUB_KEY=your_client_id
GITHUB_SECRET=your_client_secret
```

3.アプリケーションの起動
```bash
$ bin/dev
```

## 開発環境での利用
**開発用ログイン (認証バイパス)**

開発環境においては、GitHub連携を行わずにワンクリックでログインできる開発者ツールが実装されています。
1. `bin/dev`でサーバーを起動し、`http://localhost:3000/`にアクセスします。
2. **画面最下部に固定表示されている黒いバー**を確認してください。
3. 「👑管理者」または「👤一般」をクリックすると、それぞれの権限で即座にログインできます。

* 動作確認の際はこちらの使用を推奨します。

## Lint & Test
1. Lintを実行する
```bash
$ bin/lint
```
2. テストを実行する
```bash
$ bundle exec rspec
```

## 技術スタック
#### バックエンド
* Ruby 3.4.7
* Ruby on Rails 8.1.1
* SQlite 3.51.1

#### フロントエンド
* Hotwire (Turbo / Stimulus)
* ViewComponent
* Tailwind CSS

#### データベース
* SQlite

##### テスト
* RSpec
* FactoryBot
* Capybara

## ER図
```mermaid
erDiagram
    users ||--o{ exams : "受験する"

    users {
        bigint id PK
        bigint github_id "GitHub ID"
        boolean admin "管理者フラグ"
    }

    exams ||--o{ exam_questions : "含む"

    exams {
        bigint id PK
        integer user_id FK
        datetime completed_at "完了日時"
    }

    categories ||--o{ questions : "分類する"

    categories {
        bigint id PK
        integer chapter_number "章番号"
        string name "カテゴリ名"
        float weight "重み付け"
    }

    questions ||--o{ exam_questions : "出題される"
    questions ||--o{ question_choices : "持つ"

    questions {
        bigint id PK
        integer category_id FK
        text content "問題文"
        text explanation "解説"
        integer official_page "公式テキスト参照P"
        datetime deleted_at "論理削除"
    }

    question_choices ||--o{ exam_answers : "選択される"

    question_choices {
        bigint id PK
        integer question_id FK
        string content "選択肢内容"
        boolean correct "正解フラグ"
    }

    exam_questions ||--o{ exam_answers : "回答を持つ"

    exam_questions {
        bigint id PK
        integer exam_id FK
        integer question_id FK
        integer position "出題順"
    }

    exam_answers {
        bigint id PK
        integer exam_question_id FK
        integer question_choice_id FK
    }
```

## インフラ構成
Kamalを使用し、VPS上にコンテナベースでデプロイしています。
Rails 8 の標準機能を活用した、SQLiteベースのシングルサーバー構成です。
低価格で信頼性のある構成を目指しました。

### 技術スタック
* **Deployment**: Kamal (Docker on Ubuntu VPS)
* **Web Server**: Puma + Thruster (HTTP/2, Caching)
* **Database**: SQLite3
* **Backup**: Litestream + Cloudflare R2 (リアルタイムレプリケーション)
* **Reverse Proxy**: Traefik (SSL自動化)

```mermaid
graph TD
    classDef cloud fill:#f9f9f9,stroke:#333,stroke-width:2px;
    classDef storage fill:#e1f5fe,stroke:#0277bd,stroke-width:2px;
    classDef app fill:#e8f5e9,stroke:#2e7d32,stroke-width:2px;

    User((User)) -->|"HTTPS / SSL"| Traefik

    subgraph VPS ["VPS (Ubuntu / Docker)"]
        direction TB
        Traefik["Traefik (Reverse Proxy)"] -->|HTTP| Thruster

        subgraph AppContainer ["Rails 8 Container"]
            direction TB
            Thruster["Thruster (Accelerator)"] -->|Proxy| Puma["Puma (App Server)"]
            Puma -->|"Read/Write"| SQLite[("SQLite3 (Production DB)")]
            
            Litestream["Litestream (Sidecar process)"] -.->|Watch| SQLite
        end
    end

    subgraph Cloud ["Cloud Infrastructure"]
        R2[("Cloudflare R2 (Object Storage)")]:::storage
    end

    Litestream -->|"Real-time Replication (S3 API)"| R2

    Dev((Developer)) -.->|"Git Push"| GitHub["GitHub Actions"]
    GitHub -.->|"Build & Push"| Registry["Docker Registry"]
    Registry -.->|"Kamal Pull"| VPS

    class R2 cloud
    class AppContainer app
```
