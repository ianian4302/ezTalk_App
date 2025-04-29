# eztalk

An app that helps people with language impairments communicate.

## Getting Started

This project is a starting point for a Flutter application.

A few resources to get you started if this is your first Flutter project:

- [Lab: Write your first Flutter app](https://docs.flutter.dev/get-started/codelab)
- [Cookbook: Useful Flutter samples](https://docs.flutter.dev/cookbook)

For help getting started with Flutter development, view the
[online documentation](https://docs.flutter.dev/), which offers tutorials,
samples, guidance on mobile development, and a full API reference.

```
flutter run
```

請依照以上創建一個最簡單的 Flutter 環境，打開跟目錄執行命令

## 更新方式

請在 Github 拉一條分支，做完後發出 merge request

## TODO

以下是需要完成的 API

1.  資料蒐集：單句錄音 API(音檔傳輸格式與翻譯用的收音格式不一樣)
2.  資料蒐集：整句錄音 API
3.  資料蒐集：歷史錄音 API
4.  翻譯：feedback API(文件內有兩個 feedback 路徑，不確定是哪個，目前使用的是 POST https://120.126.151.159:56432/api2/feedback ，回應 500 錯誤)

以上三個錄音用 API 應該要是共用同一個地址，如果能在本地測試路徑會方便很多

## 結構

```
lib
├── api
│   └── eztalk_api.dart(API相關)
├── firebase
│   ├── auth_gate.dart(登入驗證)
│   └── firebase.dart(firebase API串接，已經寫好了不要動)
├── page
│   ├── dataCollect(資料蒐集相關)
│   ├── test(測試用，不要刪也不要使用)
│   ├── translate(翻譯相關)
├── utilities
├── widgets
│   ├── records(錄音組件，確定可使用)
└── main.dart(主目錄，盡量不要動，物件宣告為區域物件，不要宣告成全域)
```

## 測試

可使用 Android Studio 的虛擬機測試，也可以使用實機測試
https://ithelp.ithome.com.tw/articles/10302327

```
flutter build
```

如果你用來測試的手機有多設定檔可切換（例如 samsung 的工作設定檔），刪除時請檢察不同設定檔內是否存在文件，否則無法重新 build
