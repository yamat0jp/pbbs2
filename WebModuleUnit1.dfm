object WebModule1: TWebModule1
  OldCreateOrder = False
  OnCreate = WebModuleCreate
  Actions = <
    item
      Name = 'WebActionItem1'
      PathInfo = '/bbs'
      OnAction = WebModule1WebActionItem1Action
    end
    item
      Name = 'WebActionItem2'
      PathInfo = '/alert'
      OnAction = WebModule1WebActionItem2Action
    end
    item
      Default = True
      Name = 'WebActionItem3'
      PathInfo = '/top'
      OnAction = WebModule1WebActionItem3Action
    end
    item
      Name = 'WebActionItem4'
      PathInfo = '/admin'
      OnAction = WebModule1WebActionItem4Action
    end>
  Height = 321
  Width = 415
  object FDConnection1: TFDConnection
    Params.Strings = (
      'Database=C:\Users\yamat\Documents\GitHub\pbbs2\templates\DATA.IB'
      'User_Name=sysdba'
      'Password=masterkey'
      'CharacterSet=UTF8'
      'OpenMode=OpenOrCreate'
      'DriverID=iB')
    Connected = True
    Left = 328
    Top = 24
  end
  object FDTable1: TFDTable
    Active = True
    IndexFieldNames = 'dbnumber'
    Connection = FDConnection1
    UpdateOptions.UpdateTableName = 'nametable'
    TableName = 'nametable'
    Left = 328
    Top = 104
    object FDTable1DBNUMBER: TIntegerField
      FieldName = 'DBNUMBER'
      Origin = 'DBNUMBER'
      ProviderFlags = [pfInUpdate, pfInWhere, pfInKey]
      Required = True
    end
    object FDTable1DBNAME: TWideStringField
      FieldName = 'DBNAME'
      Origin = 'DBNAME'
      Required = True
      Size = 4
    end
  end
  object FDTable2: TFDTable
    Active = True
    IndexFieldNames = 'dbnumber;cmnumber'
    MasterSource = DataSource1
    MasterFields = 'dbnumber'
    Connection = FDConnection1
    UpdateOptions.UpdateTableName = 'maintable'
    TableName = 'maintable'
    Left = 328
    Top = 160
    object FDTable2DBNUMBER: TIntegerField
      FieldName = 'DBNUMBER'
      Origin = 'DBNUMBER'
      ProviderFlags = [pfInUpdate, pfInWhere, pfInKey]
      Required = True
    end
    object FDTable2CMNUMBER: TIntegerField
      FieldName = 'CMNUMBER'
      Origin = 'CMNUMBER'
      ProviderFlags = [pfInUpdate, pfInWhere, pfInKey]
      Required = True
    end
    object FDTable2TITLE: TWideStringField
      FieldName = 'TITLE'
      Origin = 'TITLE'
      Required = True
      Size = 128
    end
    object FDTable2NAME: TWideStringField
      FieldName = 'NAME'
      Origin = 'NAME'
      Required = True
      Size = 128
    end
    object FDTable2COMMENT: TWideMemoField
      FieldName = 'COMMENT'
      Origin = 'COMMENT'
      BlobType = ftWideMemo
    end
    object FDTable2DATETIME: TDateField
      FieldName = 'DATETIME'
      Origin = 'DATETIME'
      Required = True
    end
    object FDTable2RAWDATA: TWideMemoField
      FieldName = 'RAWDATA'
      Origin = 'RAWDATA'
      BlobType = ftWideMemo
    end
  end
  object DataSource1: TDataSource
    DataSet = FDTable1
    Left = 248
    Top = 24
  end
  object DataSetPageProducer1: TDataSetPageProducer
    HTMLFile = 'templates\index.htm'
    DataSet = FDTable1
    OnHTMLTag = DataSetPageProducer1HTMLTag
    Left = 48
    Top = 88
  end
  object WebFileDispatcher1: TWebFileDispatcher
    WebFileExtensions = <
      item
        MimeType = 'text/css'
        Extensions = 'css'
      end
      item
        MimeType = 'text/html'
        Extensions = 'html;htm'
      end
      item
        MimeType = 'text/javascript'
        Extensions = 'js'
      end
      item
        MimeType = 'image/jpeg'
        Extensions = 'jpeg;jpg'
      end
      item
        MimeType = 'image/x-png'
        Extensions = 'png'
      end>
    WebDirectories = <
      item
        DirectoryAction = dirInclude
        DirectoryMask = '*'
      end
      item
        DirectoryAction = dirExclude
        DirectoryMask = '\templates\*'
      end>
    RootDirectory = '.'
    Left = 48
    Top = 24
  end
  object PageProducer1: TPageProducer
    HTMLDoc.Strings = (
      '<!doctype html>'
      '<html class=no-js lang=ja>'
      '<head>'
      
        #9'<meta charset=utf-8 name="google-site-verification"  content="5' +
        'KOTJTKv1HgTtIt0zVGzuyAkADCwXRme-RiiKJ03l3s" />'
      #9'<meta http-equiv="X-UA-Compatible" content="IE=edge">'
      #9'<title>Top Page</title>'
      #9'<link rel="shortcut icon" href=img/favicon64.ico>'
      
        #9'<link rel="stylesheet" href="https://stackpath.bootstrapcdn.com' +
        '/bootstrap/4.2.1/css/bootstrap.min.css" integrity="sha384-GJzZqF' +
        'Gwb1QTTN6wy59ffF1BuGJpLSa9DkKMp0DgiMDm4iYMj70gZWKYbI706tWS" cros' +
        'sorigin="anonymous">'
      '</head>'
      '<body>'
      
        '   '#9'<script src="https://code.jquery.com/jquery-3.3.1.slim.min.j' +
        's" integrity="sha384-q8i/X+965DzO0rT7abK41JStQIAqVgRVzpbzo5smXKp' +
        '4YfRvH+8abtTE1Pi6jizo" crossorigin="anonymous"></script>'
      
        '    <script src="https://cdnjs.cloudflare.com/ajax/libs/popper.j' +
        's/1.14.6/umd/popper.min.js" integrity="sha384-wHAiFfRlMFy6i5SRax' +
        'vfOCifBUQy1xHdJ/yoi7FRNXMRBu5WHdZYu1hA6ZOblgut" crossorigin="ano' +
        'nymous"></script>'
      
        '    <script src="https://stackpath.bootstrapcdn.com/bootstrap/4.' +
        '2.1/js/bootstrap.min.js" integrity="sha384-B0UglyR+jN6CkvvICOB2j' +
        'oaf5I4l3gm9GU6Hc1og6Ls7i6U/mkkaduKaBhlAXv9k" crossorigin="anonym' +
        'ous"></script>'
      '<div id="fb-root"></div>'
      '<script>(function(d, s, id) {'
      '  var js, fjs = d.getElementsByTagName(s)[0];'
      '  if (d.getElementById(id)) return;'
      '  js = d.createElement(s); js.id = id;'
      
        '  js.src = "//connect.facebook.net/ja_JP/sdk.js#xfbml=1&version=' +
        'v2.8";'
      '  fjs.parentNode.insertBefore(js, fjs);'
      '}(document, '#39'script'#39', '#39'facebook-jssdk'#39'));</script>'
      '<header><h1 style=text-align:center>'#28961#26009#38651#23376#25522#31034#26495#12408#12424#12358#12371#12381'</h1></header>'
      ''
      '<div id="slide-1" class="carousel slide" data-ride="carousel">'
      #9'<ol class="carousel-indicators">'
      '        <#first>'
      '        </ol>'
      #9'<div class="carousel-inner bg-dark">'
      '        <#second>'
      #9'</div>'
      
        #9'<a class="carousel-control-prev" href="#slide-1" role="button" ' +
        'data-slide="prev">'
      
        #9#9'<span class="carousel-control-prev-icon" aria-hidden="true"></' +
        'span>'
      #9#9'<span class="sr-only">Previouse</span>'
      #9'</a>'
      
        #9'<a class="carousel-control-next" href="#slide-1" role="button" ' +
        'data-slide="next">'
      
        #9#9'<span class="carousel-control-next-icon" aria-hidden="true"></' +
        'span>'
      #9#9'<span class="sr-only">Next</span>'
      #9'</a>'
      #9'</div>'
      '</div>'
      ''
      '<p>'
      '<p>'#12288'<em style="background-color:aqua">'#12288#12288#12288#12288'</em>'#12539#12539#12539'new!'
      '        <#information>'
      ''
      '<p>[ <a href=/master>master</a> ] <='#31649#29702#20154
      
        '<div class="fb-like" data-href="http://pybbs.herokuapp.com" data' +
        '-layout="box_count" data-action="like" data-size="small" data-sh' +
        'ow-faces="true" data-share="false"></div><footer>'
      '<p align="center">'#12522#12531#12463#12501#12522#12540
      #9'<p align="center"><img src="img/BBS_bn.jpg">'
      '<p><a href=/search>'#20840#20307#26908#32034'</a>'
      '<p><a href=/title>'#12479#12452#12488#12523#34920#31034'</a>'
      '<p><a href=/help>'#20351#12356#26041#26696#20869'</a>'
      '<p>PR '#12522#12531#12463
      '<br>'
      
        '<p><a href=https://www.amazon.co.jp/%E9%AB%98%E6%A0%A1%E5%8D%92%' +
        'E6%A5%AD%E3%81%BE%E3%81%A7%E3%81%AE%E3%82%B5%E3%83%83%E3%82%AB%E' +
        '3%83%BC%E6%88%A6%E8%A1%93-sanuki_kainushi-ebook/dp/B00AXBM08Q/re' +
        'f=sr_1_7?ie=UTF8&qid=1479369992&sr=8-7&keywords=sanuki_kainushi>' +
        #39640#26657#21330#26989#12414#12391#12398#12469#12483#12459#12540#25126#34899'</a><br>'
      'amazon kindle</p>'
      '<p>'
      
        '<p><a href=https://www.amazon.co.jp/%E4%B8%AD%E5%AD%A6%E5%8D%92%' +
        'E6%A5%AD%E3%81%BE%E3%81%A7%E3%81%AE%E3%82%B5%E3%83%83%E3%82%AB%E' +
        '3%83%BC%E6%88%A6%E8%A1%93-sanuki_kainushi-ebook/dp/B014X0S874/re' +
        'f=sr_1_3?s=digital-text&ie=UTF8&qid=1479370246&sr=1-3>'#20013#23398#21330#26989#12414#12391#12398#12469#12483#12459 +
        #12540#25126#34899'</a><br>'
      'amazon kindle</p>'
      '</footer>'
      '</body>'
      '</html>')
    OnHTMLTag = PageProducer1HTMLTag
    Left = 48
    Top = 208
  end
  object DataSetPageProducer2: TDataSetPageProducer
    HTMLFile = 'templates/main.htm'
    DataSet = FDTable2
    OnHTMLTag = DataSetPageProducer2HTMLTag
    Left = 48
    Top = 152
  end
  object DataSetTableProducer1: TDataSetTableProducer
    Columns = <
      item
        BgColor = 'White'
        Title.Custom = 'width=5%'
        Title.BgColor = 'Aqua'
        Title.Caption = 'CHECK'
      end
      item
        FieldName = 'CMNUMBER'
        Title.Custom = 'width=5%'
        Title.BgColor = 'Aqua'
        Title.Caption = 'NUMBER'
      end
      item
        FieldName = 'TITLE'
        Title.BgColor = 'Aqua'
      end
      item
        FieldName = 'NAME'
        Title.BgColor = 'Aqua'
      end
      item
        BgColor = 'White'
        Title.Custom = 'width=5%'
        Title.BgColor = 'Aqua'
        Title.Caption = 'LINK'
      end>
    DataSet = FDTable2
    TableAttributes.BgColor = 'White'
    OnFormatCell = DataSetTableProducer1FormatCell
    Left = 328
    Top = 216
  end
  object PageProducer2: TPageProducer
    HTMLDoc.Strings = (
      '<html>'
      '<head>'
      '<meta charset="utf-8">'
      '</head>'
      '<body>'
      '  <link rel=stylesheet href=css/main.css>'
      
        '<link rel="stylesheet" href="https://stackpath.bootstrapcdn.com/' +
        'bootstrap/4.2.1/css/bootstrap.min.css" integrity="sha384-GJzZqFG' +
        'wb1QTTN6wy59ffF1BuGJpLSa9DkKMp0DgiMDm4iYMj70gZWKYbI706tWS" cross' +
        'origin="anonymous">'
      '<form class=setting action=/admin?db=<#dbname> method=post>'
      '<input type=hidden name=change value=true>'
      
        #21517#31216#65306'<input type=edit name=text value=<#dbname>><input type=submit' +
        ' value="'#22793#26356'">'
      '</form>'
      '<form class=delete action=/top?db=<#dbname> method=post>'
      '<p style=align:center><input type=submit value="'#20840#21066#38500'">'
      '</form>'
      '<form action=/admin?db=<#dbname> method=post>'
      '<#table>'
      '<input type=submit value="'#21066#38500'"><input type=reset value="'#21462#12426#28040#12375'">'
      '</form>'
      '<#footer>'
      '<#section>'
      '<a href=/bbs?db=<#dbname>>'#12418#12393#12427'</a>'
      '</body>'
      '</html>')
    OnHTMLTag = PageProducer2HTMLTag
    Left = 328
    Top = 264
  end
  object DataSetPageProducer3: TDataSetPageProducer
    HTMLFile = 'templates/alert.htm'
    DataSet = FDTable1
    OnHTMLTag = DataSetPageProducer3HTMLTag
    Left = 48
    Top = 256
  end
end
