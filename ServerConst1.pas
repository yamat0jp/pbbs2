unit ServerConst1;

interface

resourcestring
  sPortInUse = '- エラー: ポート %s は既に使用中です';
  sPortSet = '- ポートが %s に設定されました';
  sServerRunning = '- サーバーが既に稼働しています';
  sStartingServer = '- HTTP サーバーをポート %d で起動しています';
  sStoppingServer = '- サーバーを停止しています';
  sServerStopped = '- サーバーが停止しました';
  sServerNotRunning = '- サーバーが稼働していません';
  sInvalidCommand = '- エラー: コマンドが無効です';
  sIndyVersion = '- Indy バージョン: ';
  sActive = '- アクティブ: ';
  sPort = '- ポート: ';
  sSessionID = '- セッション ID クッキー名: ';
  sCommands = '次のいずれかのコマンドを入力します: '#13#10'   - "start" (サーバーを起動)'#13#10'   - "stop" (サーバーを停止)'#13#10'   - "set port" (デフォルト ポートを変更)'#13#10'   - "status" (サーバーの状態を表示)'#13#10'   - "help" (コマンドを表示)'#13#10'   - "exit" (アプリケーションを終了)';

const
  cArrow = '->';
  cCommandStart = 'start';
  cCommandStop = 'stop';
  cCommandStatus = 'status';
  cCommandHelp = 'help';
  cCommandSetPort = 'set port';
  cCommandExit = 'exit';

implementation

end.
