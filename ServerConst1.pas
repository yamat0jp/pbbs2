unit ServerConst1;

interface

resourcestring
  sPortInUse = '- �G���[: �|�[�g %s �͊��Ɏg�p���ł�';
  sPortSet = '- �|�[�g�� %s �ɐݒ肳��܂���';
  sServerRunning = '- �T�[�o�[�����ɉғ����Ă��܂�';
  sStartingServer = '- HTTP �T�[�o�[���|�[�g %d �ŋN�����Ă��܂�';
  sStoppingServer = '- �T�[�o�[���~���Ă��܂�';
  sServerStopped = '- �T�[�o�[����~���܂���';
  sServerNotRunning = '- �T�[�o�[���ғ����Ă��܂���';
  sInvalidCommand = '- �G���[: �R�}���h�������ł�';
  sIndyVersion = '- Indy �o�[�W����: ';
  sActive = '- �A�N�e�B�u: ';
  sPort = '- �|�[�g: ';
  sSessionID = '- �Z�b�V���� ID �N�b�L�[��: ';
  sCommands = '���̂����ꂩ�̃R�}���h����͂��܂�: '#13#10'   - "start" (�T�[�o�[���N��)'#13#10'   - "stop" (�T�[�o�[���~)'#13#10'   - "set port" (�f�t�H���g �|�[�g��ύX)'#13#10'   - "status" (�T�[�o�[�̏�Ԃ�\��)'#13#10'   - "help" (�R�}���h��\��)'#13#10'   - "exit" (�A�v���P�[�V�������I��)';

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
