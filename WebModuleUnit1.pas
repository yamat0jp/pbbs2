unit WebModuleUnit1;

interface

uses System.SysUtils, System.Classes, Web.HTTPApp, FireDAC.Stan.Intf,
  FireDAC.Stan.Option, FireDAC.Stan.Error, FireDAC.UI.Intf, FireDAC.Phys.Intf,
  FireDAC.Stan.Def, FireDAC.Stan.Pool, FireDAC.Stan.Async, FireDAC.Phys,
  FireDAC.Phys.MySQL, FireDAC.Phys.MySQLDef, FireDAC.Stan.Param, FireDAC.DatS,
  FireDAC.DApt.Intf, FireDAC.DApt, Data.DB, FireDAC.Comp.DataSet,
  FireDAC.Comp.Client, Web.HTTPProd, Web.DSProd, Datasnap.DSCommonServer,
  Datasnap.DSServer, Datasnap.DSMetadata, Datasnap.DSServerMetadata,
  IPPeerServer, Datasnap.DSHTTP, Datasnap.DSHTTPWebBroker,
  Datasnap.DSProxyDispatcher, IPPeerClient, Datasnap.DSClientRest,
  Datasnap.DSClientMetadata, Datasnap.DSProxyJavaScript, Datasnap.DSHTTPCommon,
  Web.DBWeb, FireDAC.Stan.ExprFuncs, IniFiles, FireDAC.Phys.IB,
  FireDAC.Phys.IBDef;

type
  TWebModule1 = class(TWebModule)
    FDConnection1: TFDConnection;
    FDTable1: TFDTable;
    FDTable2: TFDTable;
    DataSource1: TDataSource;
    DataSetPageProducer1: TDataSetPageProducer;
    WebFileDispatcher1: TWebFileDispatcher;
    PageProducer1: TPageProducer;
    DataSetPageProducer2: TDataSetPageProducer;
    DataSetTableProducer1: TDataSetTableProducer;
    FDTable1DBNUMBER: TIntegerField;
    FDTable1DBNAME: TWideStringField;
    FDTable2DBNUMBER: TIntegerField;
    FDTable2CMNUMBER: TIntegerField;
    FDTable2COMMENT: TWideMemoField;
    FDTable2DATETIME: TDateField;
    PageProducer2: TPageProducer;
    FDTable2TITLE: TWideStringField;
    FDTable2NAME: TWideStringField;
    FDTable2RAWDATA: TWideMemoField;
    DataSetPageProducer3: TDataSetPageProducer;
    PageProducer3: TPageProducer;
    procedure WebModule1WebActionItem1Action(Sender: TObject;
      Request: TWebRequest; Response: TWebResponse; var Handled: Boolean);
    procedure DataSetPageProducer1HTMLTag(Sender: TObject; Tag: TTag;
      const TagString: string; TagParams: TStrings; var ReplaceText: string);
    procedure WebModule1WebActionItem3Action(Sender: TObject;
      Request: TWebRequest; Response: TWebResponse; var Handled: Boolean);
    procedure PageProducer1HTMLTag(Sender: TObject; Tag: TTag;
      const TagString: string; TagParams: TStrings; var ReplaceText: string);
    procedure DataSetPageProducer2HTMLTag(Sender: TObject; Tag: TTag;
      const TagString: string; TagParams: TStrings; var ReplaceText: string);
    procedure WebModule1WebActionItem4Action(Sender: TObject;
      Request: TWebRequest; Response: TWebResponse; var Handled: Boolean);
    procedure DataSetTableProducer1FormatCell(Sender: TObject;
      CellRow, CellColumn: Integer; var BgColor: THTMLBgColor;
      var Align: THTMLAlign; var VAlign: THTMLVAlign;
      var CustomAttrs, CellData: string);
    procedure WebModuleCreate(Sender: TObject);
    procedure PageProducer2HTMLTag(Sender: TObject; Tag: TTag;
      const TagString: string; TagParams: TStrings; var ReplaceText: string);
    procedure WebModule1WebActionItem2Action(Sender: TObject;
      Request: TWebRequest; Response: TWebResponse; var Handled: Boolean);
    procedure DataSetPageProducer3HTMLTag(Sender: TObject; Tag: TTag;
      const TagString: string; TagParams: TStrings; var ReplaceText: string);
    procedure PageProducer3HTMLTag(Sender: TObject; Tag: TTag;
      const TagString: string; TagParams: TStrings; var ReplaceText: string);
    procedure WebModule1WebActionItem5Action(Sender: TObject;
      Request: TWebRequest; Response: TWebResponse; var Handled: Boolean);
  private
    { private �錾 }
    count: Integer;
    pagecount: Integer;
    procedure makeComment(list: TStringList);
    function makeFooter(script: string): string;
    function ActiveRecordisNew: Boolean;
    function FindText(word: string): string;
  public
    { public �錾 }
  end;

var
  WebModuleClass: TComponentClass = TWebModule1;

implementation

{ %CLASSGROUP 'Vcl.Controls.TControl' }

{$R *.dfm}

function TWebModule1.ActiveRecordisNew: Boolean;
var
  date: TDateTime;
begin
  FDTable2.Last;
  date := Now - FDTable2.FieldByName('datetime').AsDateTime;
  result := date < 1;
end;

procedure TWebModule1.DataSetPageProducer1HTMLTag(Sender: TObject; Tag: TTag;
  const TagString: string; TagParams: TStrings; var ReplaceText: string);
var
  i, cnt: Integer;
  s: string;
begin
  if TagString = 'main' then
  begin
    i := StrToIntDef(Request.QueryFields.Values['page'], 0);
    if (i = 0) or (i * count > FDTable2.RecordCount) then
    begin
      FDTable2.Last;
      FDTable2.MoveBy(-count + 1);
    end
    else
    begin
      FDTable2.First;
      FDTable2.MoveBy((i - 1) * count);
    end;
    cnt := count;
    s := FDTable1.FieldByName('dbname').AsString;
    while (FDTable2.Eof = false) and (cnt > 0) do
    begin
      ReplaceText := ReplaceText + DataSetPageProducer2.Content +
        Format('<p style=text-align:end><a href=/alert?db=%s&page=%d>��</a>',
        [s, FDTable2.FieldByName('cmnumber').AsInteger]);
      FDTable2.Next;
      dec(cnt);
    end;
  end
  else if TagString = 'footer' then
    ReplaceText := makeFooter('bbs');;
end;

procedure TWebModule1.DataSetPageProducer2HTMLTag(Sender: TObject; Tag: TTag;
  const TagString: string; TagParams: TStrings; var ReplaceText: string);
begin
  if TagString = 'dbname' then
    ReplaceText := FDTable1.FieldByName('dbname').AsString
  else if TagString = 'comment' then
    ReplaceText := FDTable2.FieldByName('comment').AsString;
end;

procedure TWebModule1.DataSetPageProducer3HTMLTag(Sender: TObject; Tag: TTag;
  const TagString: string; TagParams: TStrings; var ReplaceText: string);
begin
  if TagString = 'article' then
  begin
    if DataSetPageProducer3.Tag = 0 then
      ReplaceText := DataSetPageProducer2.Content;
  end
  else if TagString = 'message' then
  begin
    if DataSetPageProducer3.Tag = 0 then
      ReplaceText :=
        '<textarea name=com></textarea><p style=text-align:center><input name=admit type=submit value="���M">'
    else
      ReplaceText := '�����͂��肪�Ƃ��������܂���';
  end
  else if TagString = 'query' then
    ReplaceText := string(Request.Query);
end;

procedure TWebModule1.DataSetTableProducer1FormatCell(Sender: TObject;
  CellRow, CellColumn: Integer; var BgColor: THTMLBgColor;
  var Align: THTMLAlign; var VAlign: THTMLVAlign;
  var CustomAttrs, CellData: string);
var
  s: string;
begin
  if CellRow > 0 then
    case CellColumn of
      0:
        CellData := Format('<input type=checkbox name=check value=%d>',
          [FDTable2.FieldByName('cmnumber').AsInteger]);
      4:
        begin
          s := Request.QueryFields.Values['page'];
          if s <> '' then
            s := '&page=' + s;
          CellData := Format('<a href=/admin?db=%s%s&link=%d>go</a>',
            [Request.QueryFields.Values['db'], s,
            FDTable2.FieldByName('cmnumber').AsInteger]);
        end;
    end;
  if (CellRow > 1) and (CellRow and 1 = 0) then
    BgColor := 'Silver';
end;

function TWebModule1.FindText(word: string): string;
var
  list: TStringList;
  i, j: Integer;
  s, t, p: string;
  x: Boolean;
begin
  if Length(word) = 0 then
    Exit;
  x := false;
  list := TStringList.Create;
  try
    list.Text := FDTable2.FieldByName('rawdata').AsString;
    i := 0;
    j := 1;
    while i < list.count do
    begin
      if Length(list[i]) = 0 then
      begin
        inc(i);
        continue;
      end;
      if i < list.count - 1 then
        s := list[i] + list[i + 1]
      else
        s := list[i];
      if j > Length(s) then
        j := 1;
      while j <= Length(list[i]) do
        if (SameText(s[j], word[1]) = true) and
          (SameText(Copy(s, j, Length(word)), word) = true) then
        begin
          if j + Length(word) - 1 <= Length(list[i]) then
          begin
            s := list[i];
            x := true;
            p := Copy(s, j, Length(word));
            t := Format('<span style=background-color:yellow>%s</span>', [p]);
            list[i] := Copy(s, 1, j - 1) + t + Copy(s, j + Length(word),
              Length(s));
            s := list[i];
            inc(j, Length(t));
            continue;
          end
          else
          begin
            s := list[i];
            x := true;
            p := Copy(s, j, Length(word));
            t := Format('<span style=background-color:yellow>%s</span>', [p]);
            list[i] := Copy(s, 1, j - 1) + t;
            s := list[i + 1];
            p := Copy(s, 1, Length(word) - Length(p));
            t := Format('<span style=background-color:yellow>%s</span>', [p]);
            list[i + 1] := t + Copy(s, Length(p) + 1, Length(s));
            inc(j, Length(p));
            break;
          end;
        end
        else
          inc(j);
      inc(i);
    end;
    makeComment(list);
    if x = true then
      result := list.Text
    else
      result := '';
  finally
    list.Free;
  end;
end;

procedure TWebModule1.makeComment(list: TStringList);
var
  i: Integer;
begin
  for i := 0 to list.count - 1 do
    list[i] := list[i] + '<br>';
end;

function TWebModule1.makeFooter(script: string): string;
var
  list: TStringList;
  i, j: Integer;
  s, t, p: string;
begin
  if script = 'bbs' then
    p := '������'
  else
    p := '�͂���';
  if Request.QueryFields.Values['page'] = '' then
  begin
    t := 'active';
    j := 0;
  end
  else
    j := Request.QueryFields.Values['page'].ToInteger;
  list := TStringList.Create;
  try
    list.Add('<nav aria-label="Page navigation"><ul class="pagination pagination-sm justify-content-center">');
    s := Request.QueryFields.Values['db'];
    for i := 1 to pagecount do
    begin
      if i = j then
        list.Add('<li class="page-item active">')
      else
        list.Add('<li class="page-item">');
      list.Add(Format
        ('<a class="page-link" href="/%s?db=%s&page=%d">%d</a></li>',
        [script, s, i, i]));
    end;
    list.Add(Format
      ('<li class="page-item %s"><a class="page-link" href=/%s?db=%s>%s</a></li></ul></nav>',
      [t, script, s, p]));
    result := list.Text;
  finally
    list.Free;
  end;
end;

procedure TWebModule1.PageProducer1HTMLTag(Sender: TObject; Tag: TTag;
  const TagString: string; TagParams: TStrings; var ReplaceText: string);
const
  conf = 7;
var
  s, t: string;
  i: Integer;
  j: Integer;
  list: TStringList;
begin
  if TagString = 'main' then
  begin
    FDTable1.First;
    while FDTable1.Eof = false do
    begin
      s := FDTable1.FieldByName('dbname').AsString;
      ReplaceText := ReplaceText +
        Format('<p><a href=/bbs?db=%s>%s</a></p>', [s, s]);
      FDTable1.Next;
    end;
  end
  else if TagString = 'first' then
  begin
    for i := 0 to (FDTable1.RecordCount - 1) div conf do
      if i = 0 then
        ReplaceText :=
          '<li data-target="#slide-1" data-slide-to="0" class="active"></li>'
      else
        ReplaceText := ReplaceText +
          Format('<li data-target="#slide-1" data-slide-to=%d></li>', [i]);
  end
  else if TagString = 'second' then
  begin
    list := TStringList.Create;
    try
      FDTable1.First;
      for i := 0 to (FDTable1.RecordCount - 1) div conf do
      begin
        if i = 0 then
          list.Add('<div class="carousel-item active">')
        else
          list.Add('<div class="carousel-item">');
        list.Add(Format
          ('<img class="d-sm-block d-none" src=img/slide%d.jpg style="float:right;height:465px">',
          [i + 1]));
        list.Add('<div style="height:465px"></div>');
        list.Add('<div class="carousel-caption text-left" style="font-size:1.5rem;">');
        for j := 1 to conf do
        begin
          t := FDTable1.FieldByName('dbname').AsString;
          if FDTable1.Eof = true then
            break;
          if ActiveRecordisNew = true then
            s := 'background-color:aqua'
          else
            s := '';
          FDTable1.Next;
          list.Add(Format
            ('<p><a href=/bbs?db=%s style=%s; target=_blank>%s</a>',
            [t, s, t]));
        end;
        list.Add('</div></div>');
      end;
      ReplaceText := list.Text;
    finally
      list.Free;
    end;
  end;
end;

procedure TWebModule1.PageProducer2HTMLTag(Sender: TObject; Tag: TTag;
  const TagString: string; TagParams: TStrings; var ReplaceText: string);
begin
  if TagString = 'table' then
    ReplaceText := DataSetTableProducer1.Content
  else if TagString = 'dbname' then
    ReplaceText := Request.QueryFields.Values['db']
  else if TagString = 'footer' then
    ReplaceText := makeFooter('admin')
  else if (TagString = 'section') and
    (FDTable2.Locate('cmnumber', PageProducer2.Tag) = true) then
    ReplaceText := DataSetPageProducer2.Content;
end;

procedure TWebModule1.PageProducer3HTMLTag(Sender: TObject; Tag: TTag;
  const TagString: string; TagParams: TStrings; var ReplaceText: string);
var
  list: TStringList;
  s, t: string;
begin
  if (TagString = 'main') and (Request.MethodType = mtPost) then
  begin
    s := Request.ContentFields.Values['word1'];
    list := TStringList.Create;
    try
      FDTable1.First;
      while FDTable1.Eof = false do
      begin
        while FDTable2.Eof = false do
        begin
          t := FindText(s);
          if t <> '' then
          begin
            list.Add(t);
            list.Add('<hr>');
          end;
          FDTable2.Next;
        end;
        FDTable1.Next;
      end;
      if list.count > 0 then
        ReplaceText := list.Text
      else
        ReplaceText := '������܂���ł���';
    finally
      list.Free;
    end;
  end;
end;

procedure TWebModule1.WebModule1WebActionItem1Action(Sender: TObject;
  Request: TWebRequest; Response: TWebResponse; var Handled: Boolean);
var
  title, name, raw: string;
  dbname: string;
  list: TStringList;
  i: Integer;
begin
  dbname := Request.QueryFields.Values['db'];
  if (dbname <> '') and (FDTable1.Locate('dbname', dbname) = false) then
  begin
    FDTable1.Last;
    i := FDTable1.FieldByName('dbnumber').AsInteger + 1;
    FDTable1.AppendRecord([i, dbname]);
  end;
  if Request.MethodType = mtPost then
  begin
    title := Request.ContentFields.Values['title'];
    name := Request.ContentFields.Values['name'];
    if title = '' then
      title := '�^�C�g���Ȃ�.';
    if name = '' then
      name := 'no name';
    raw := Request.ContentFields.Values['comment'];
    FDTable2.Last;
    i := FDTable2.FieldByName('cmnumber').AsInteger + 1;
    list := TStringList.Create;
    try
      list.Text := raw;
      makeComment(list);
      FDTable2.AppendRecord([FDTable1.FieldByName('dbnumber').AsInteger, i,
        title, name, list.Text, Now, raw]);
    finally
      list.Free;
    end;
  end;
  Response.ContentType := 'text/html;charset=utf-8';
  Response.Content := DataSetPageProducer1.Content;
end;

procedure TWebModule1.WebModule1WebActionItem2Action(Sender: TObject;
  Request: TWebRequest; Response: TWebResponse; var Handled: Boolean);
var
  stream: TFileStream;
  list: TStringList;
begin
  if (FDTable1.Locate('dbname', Request.QueryFields.Values['db']) = false) or
    (FDTable2.Locate('cmnumber', Request.QueryFields.Values['page']) = false)
  then
  begin
    Handled := false;
    Exit;
  end;
  if Request.MethodType = mtGet then
    DataSetPageProducer3.Tag := 0
  else if Request.MethodType = mtPost then
  begin
    DataSetPageProducer3.Tag := 1;
    if FileExists('templates/voice.txt') = true then
      stream := TFileStream.Create('templates/voice.txt', fmOpenReadWrite)
    else
      stream := TFileStream.Create('templates/voice.txt', fmCreate);
    stream.Position := stream.Size;
    list := TStringList.Create;
    try
      list.Add('');
      list.Add('(*���[�U�[�l����񍐂�����܂���*)');
      list.Add(FDTable1.FieldByName('dbname').AsString);
      list.Add(FDTable2.FieldByName('cmnumber').AsString);
      list.Add(FDTable2.FieldByName('title').AsString);
      list.Add(FDTable2.FieldByName('name').AsString);
      list.Add(FDTable2.FieldByName('datetime').AsString);
      list.Add(FDTable2.FieldByName('rawdata').AsString);
      list.Add(Request.ContentFields.Values['com']);
      list.Add('(*�񍐂����܂�*)');
      list.Add('');
      list.SaveToStream(stream);
    finally
      stream.Free;
      list.Free;
    end;
  end;
  Response.ContentType := 'text/html;charset=utf-8';
  Response.Content := DataSetPageProducer3.Content;
end;

procedure TWebModule1.WebModule1WebActionItem3Action(Sender: TObject;
  Request: TWebRequest; Response: TWebResponse; var Handled: Boolean);
begin
  if (Request.MethodType = mtPost) and
    (FDTable1.Locate('dbname', Request.QueryFields.Values['db']) = true) then
  begin
    FDTable2.First;
    while FDTable2.Eof = false do
      FDTable2.Delete;
    FDTable1.Delete;
  end;
  Response.ContentType := 'text/html;charset=utf-8';
  Response.Content := PageProducer1.ContentFromString(PageProducer1.Content);
end;

procedure TWebModule1.WebModule1WebActionItem4Action(Sender: TObject;
  Request: TWebRequest; Response: TWebResponse; var Handled: Boolean);
var
  s, t: string;
  i: Integer;
begin
  s := Request.QueryFields.Values['db'];
  if FDTable1.Locate('dbname', s) = false then
  begin
    Handled := false;
    Exit;
  end;
  if Request.MethodType = mtPost then
  begin
    if Request.ContentFields.Values['change'] = 'true' then
    begin
      FDTable1.Edit;
      FDTable1.FieldByName('dbname').AsString :=
        Request.ContentFields.Values['text'];
      FDTable1.Post;
    end
    else
    begin
      s := '';
      t := '';
      for i := 0 to Request.ContentFields.count - 1 do
        if Request.ContentFields.Names[i] = 'check' then
        begin
          s := s + t + 'cmnumber=''' + Request.ContentFields.ValueFromIndex
            [i] + '''';
          t := ' OR ';
        end;
      FDTable2.Filtered := false;
      FDTable2.Filter := s;
      FDTable2.Filtered := true;
      FDTable2.First;
      while FDTable2.Eof = false do
        FDTable2.Delete;
      FDTable2.Filtered := false;
    end;
  end;
  i := StrToIntDef(Request.QueryFields.Values['page'], 0);
  FDTable2.First;
  FDTable2.MoveBy((i - 1) * 2 * count);
  PageProducer2.Tag := StrToIntDef(Request.QueryFields.Values['link'], 0);
  Response.ContentType := 'text/html;charset=utf-8;';
  Response.Content := PageProducer2.Content;
end;

procedure TWebModule1.WebModule1WebActionItem5Action(Sender: TObject;
  Request: TWebRequest; Response: TWebResponse; var Handled: Boolean);
begin
  Response.ContentType := 'text/html;charset=utf-8';
  Response.Content := PageProducer3.Content;
end;

procedure TWebModule1.WebModuleCreate(Sender: TObject);
var
  ini: TIniFile;
begin
  ini := TIniFile.Create('templates/setting.ini');
  try
    count := ini.ReadInteger('data', 'count', 10);
    pagecount := ini.ReadInteger('data', 'pagecount', 10);
  finally
    ini.Free;
  end;
  DataSetTableProducer1.MaxRows := 2 * count;
end;

end.
