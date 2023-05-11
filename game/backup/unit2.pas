unit Unit2;

{$mode ObjFPC}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, StdCtrls, ExtCtrls;

type

  { TWireGame }

  TWireGame = class(TForm)
    PrintTimer: TTimer;
    procedure FormClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure PrintTimerExecute(Sender: TObject);
  private
    procedure GenerateConnectors();
  public

  end;

  TConnector = class
  public
    x : integer;
    y : integer;
    width:integer;
    height:integer;
    color : TColor;
   constructor Create(posX, posY:integer; cl: TColor);
  end;

var
  WireGame: TWireGame;
  x0,y0,x1,y1: integer;
  connectors : TList;

implementation

{$R *.lfm}

{ TWireGame }

// конструктор коннектора
constructor TConnector.Create(posX, posY:integer; cl: TColor);
begin
  x := posX;
  y := posY;
  color := cl;
end;

procedure TWireGame.FormClick(Sender: TObject);
begin

end;

// создание точек подключения
procedure TWireGame.GenerateConnectors();
const WIRECOUNT = 3;
var
  connector, connector2 : TConnector;
  i : integer;
  colors : array[1..3] of TColor;
begin
  colors[1] := clRed;
  colors[2] := clGreen;
  colors[3] := clYellow;
  for i := 1 to WIRECOUNT do
  begin
     connectors.Add(TConnector.Create(
       i * 10,
       i * 10,
       colors[i]
     ));

     connectors.Add(TConnector.Create(
       i * 10 + 100,
       i * 10 + 50,
       colors[i]
     ));
  end;
end;

// сброс координат
procedure ResetCoords();
begin
  x0 := -1;
  y0 := -1;
  x1 := -1;
  y1 := -1;
end;

procedure TWireGame.FormCreate(Sender: TObject);
begin
  GenerateConnectors();
  connectors := TList.Create;
  ResetCoords();
end;

// определение координат для провода
procedure TWireGame.FormMouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: integer);
begin
   if (x0 > 0)and(y0 > 0) then
   begin
     x1 := X;
     y1 := Y;
   end else
   begin
     x0 := X;
     y0 := Y;
   end;
end;

// отрисовка провода
procedure TWireGame.PrintTimerExecute(Sender: TObject);
begin
  if (x0 > 0)and(y0 > 0)and(x1 > 0)and(y1 > 0)then
  begin
    Canvas.Pen.Color := clGreen;
    Canvas.Pen.Width := 10;
    Canvas.Line(x0,y0,x1,y1);
    ResetCoords();
  end;
end;

end.

