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
  private
    { private 宣言 }
    count: Integer;
    pagecount: Integer;
    procedure makeComment(list: TStringList);
    function makeFooter: string;
    function makeInfoName: string;
    function ActiveRecordisNew: Boolean;
  public
    { public 宣言 }
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
  stream: TStream;
  list: TStringList;
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
    while (FDTable2.Eof = false) and (cnt > 0) do
    begin
      ReplaceText := ReplaceText + DataSetPageProducer2.Content;
      FDTable2.Next;
      dec(cnt);
    end;
  end
  else if TagString = 'footer' then
    ReplaceText := makeFooter;
end;

procedure TWebModule1.DataSetPageProducer2HTMLTag(Sender: TObject; Tag: TTag;
  const TagString: string; TagParams: TStrings; var ReplaceText: string);
var
  list: TStringList;
  stream: TStream;
begin
  if TagString = 'dbname' then
    ReplaceText := FDTable1.FieldByName('dbname').AsString
  else if TagString = 'comment' then
  begin
    list := TStringList.Create;
    stream := FDTable2.CreateBlobStream
      (FDTable2.FieldByName('comment'), bmRead);
    try
      list.LoadFromStream(stream);
      ReplaceText := list.Text;
    finally
      list.Free;
      stream.Free;
    end;
  end;
end;

procedure TWebModule1.DataSetTableProducer1FormatCell(Sender: TObject;
  CellRow, CellColumn: Integer; var BgColor: THTMLBgColor;
  var Align: THTMLAlign; var VAlign: THTMLVAlign;
  var CustomAttrs, CellData: string);
begin
  if (CellRow > 0) and (CellColumn = 0) then
    CellData := Format('<input type=checkbox name=check value=%d>',
      [FDTable2.FieldByName('cmnumber').AsInteger]);
end;

procedure TWebModule1.makeComment(list: TStringList);
var
  i: Integer;
begin
  for i := 0 to list.count - 1 do
    list[i] := list[i] + '<br>';
end;

function TWebModule1.makeFooter: string;
var
  list: TStringList;
  i, j: Integer;
  s, t: string;
begin
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
        ('<a class="page-link" href="/bbs?db=%s&page=%d">%d</a></li>',
        [s, i, i]));
    end;
    list.Add(Format
      ('<li class="page-item %s"><a class="page-link" href=/bbs?db=%s>さいご</a></li></ul></nav>',
      [t, s]));
    result := list.Text;
  finally
    list.Free;
  end;
end;

function TWebModule1.makeInfoName: string;
var
  ini: TIniFile;
begin
  ini := TIniFile.Create('templates\setting.ini');
  try
    result := ini.ReadString('data', 'name', 'info');
  finally
    ini.Free;
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
  end
  else if TagString = 'information' then
  begin
    t := makeInfoName;
    ReplaceText := Format('<p>[ <a href=/bbs?db=%s>%s</a> ] <=お知らせ', [t, t]);
  end;
end;

procedure TWebModule1.PageProducer2HTMLTag(Sender: TObject; Tag: TTag;
  const TagString: string; TagParams: TStrings; var ReplaceText: string);
begin
  if TagString = 'table' then
    ReplaceText := DataSetTableProducer1.Content
  else if TagString = 'dbname' then
    ReplaceText := Request.QueryFields.Values['db'];
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
      title := 'タイトルなし.';
    if name = '' then
      name := 'no name';
    raw := Request.ContentFields.Values['comment'];
    FDTable2.Last;
    i := FDTable2.FieldByName('cmnumber').AsInteger + 1;
    list := TStringList.Create;
    try
      list.Text := raw;
      makeComment(list);
      FDTable2.AppendRecord([FDTable1.FieldByName('dbnumber').AsInteger, i, title,
        name, list.Text, Now, raw]);
    finally
      list.Free;
    end;
  end;
  Response.ContentType := 'text/html;charset=utf-8';
  Response.Content := DataSetPageProducer1.Content;
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
  Response.ContentType := 'text/html;charset=utf-8;';
  Response.Content := PageProducer2.Content;
end;

procedure TWebModule1.WebModuleCreate(Sender: TObject);
var
  ini: TIniFile;
begin
  ini := TIniFile.Create('templates\setting.ini');
  try
    count := ini.ReadInteger('data', 'count', 10);
    pagecount := ini.ReadInteger('data', 'pagecount', 10);
  finally
    ini.Free;
  end;
end;

end.
