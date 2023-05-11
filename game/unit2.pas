unit Unit2;

{$mode ObjFPC}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, StdCtrls, ExtCtrls,
  Buttons;

type

  { TWireGame }

  TWireGame = class(TForm)
    BitBtn1: TBitBtn;
    BitBtn2: TBitBtn;
    BitBtn3: TBitBtn;
    BitBtn4: TBitBtn;
    BitBtn5: TBitBtn;
    BitBtn6: TBitBtn;
    respawnBtn: TButton;
    Label1: TLabel;
    procedure BitBtn1Click(Sender: TObject);
    procedure BitBtn2Click(Sender: TObject);
    procedure BitBtn3Click(Sender: TObject);
    procedure BitBtn4Click(Sender: TObject);
    procedure BitBtn5Click(Sender: TObject);
    procedure BitBtn6Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormShow(Sender: TObject);
  private
     procedure ResetCoords();
     procedure ResetColor();
     procedure SelectColor(cl : TColor);
     procedure SelectPoint(point : TPoint);
     procedure DraWire();
  public

  end;

  TPattern = record
    text: string;
    color: TColor;
  end;

var
  WireGame: TWireGame;
  point1, point2: TPoint;
  color1,color2 : TColor;
  btns1,btns2 : TList;
  prevColors: array[1..3]of TColor;
  count:integer;
implementation

{$R *.lfm}

{ TWireGame }

// рисование провода
procedure TWireGame.DraWire();
begin
  if (color2 = color1)and(color2 not in prevColors)then
  begin
    Dec(count);
    if count <= 0 then
    begin
      prevColors.Clear;
      BitBtn1.Enabled:=false;
      BitBtn2.Enabled:=false;
      BitBtn3.Enabled:=false;
      BitBtn4.Enabled:=false;
      BitBtn5.Enabled:=false;
      BitBtn6.Enabled:=false;
      respawnBtn.Enabled:=true;
    end;
    Canvas.Pen.Color := color2;
    Canvas.Line(point1, point2);
  end;
  ResetCoords();
  ResetColor();
end;

// сброс координат
procedure TWireGame.ResetCoords();
begin
 point1:=point1.Zero;
 point2:=point2.Zero;
end;

// сброс цвета
procedure TWireGame.ResetColor();
begin
 color1 := clNone;
 color2 := clNone;
end;

// определение цвета провода
procedure TWireGame.SelectColor(cl : TColor);
begin
 if color1 = clNone then
 begin
   color1 := cl;
 end else
 begin
   color2 := cl;
 end;
end;

// определение точек для отрисовки провода
procedure TWireGame.SelectPoint(point : TPoint);
begin
  if not(point1.IsZero) then
  begin
    point2 := point;
    DraWire();
  end else
  begin
    point1 := point;
  end;
end;

procedure TWireGame.BitBtn1Click(Sender: TObject);
begin
  SelectColor(BitBtn1.Font.Color);
  SelectPoint(BitBtn1.ReadBounds.CenterPoint);
end;

procedure TWireGame.BitBtn2Click(Sender: TObject);
begin
  SelectColor(BitBtn2.Font.Color);
  SelectPoint(BitBtn2.ReadBounds.CenterPoint);
end;

procedure TWireGame.BitBtn3Click(Sender: TObject);
begin
  SelectColor(BitBtn3.Font.Color);
  SelectPoint(BitBtn3.ReadBounds.CenterPoint);
end;

procedure TWireGame.BitBtn4Click(Sender: TObject);
begin
  SelectColor(BitBtn4.Font.Color);
  SelectPoint(BitBtn4.ReadBounds.CenterPoint);
end;

procedure TWireGame.BitBtn5Click(Sender: TObject);
begin
  SelectColor(BitBtn5.Font.Color);
  SelectPoint(BitBtn5.ReadBounds.CenterPoint);
end;

procedure TWireGame.BitBtn6Click(Sender: TObject);
begin
  SelectColor(BitBtn6.Font.Color);
  SelectPoint(BitBtn6.ReadBounds.CenterPoint);
end;

procedure TWireGame.FormCreate(Sender: TObject);
begin
  with Self, Constraints do begin
    MaxHeight:= Height;
    MinHeight:= Height;
    MaxWidth:= Width;
    MinWidth:= Width;
  end;
  Canvas.Pen.Width := 10;
end;

// рандомная генерация клемм
procedure TWireGame.FormShow(Sender: TObject);
var
  i,j,z : integer;
  arr : array[1..3] of TPattern;
begin
  BitBtn1.Enabled:=true;
  BitBtn2.Enabled:=true;
  BitBtn3.Enabled:=true;
  BitBtn4.Enabled:=true;
  BitBtn5.Enabled:=true;
  BitBtn6.Enabled:=true;
  respawnBtn.Enabled:=false;
  count := 3;
  BitBtn1Click(Sender);
  BitBtn2Click(Sender);
  btns1 := TList.Create;
  btns1.Add(BitBtn1);
  btns1.Add(BitBtn2);
  btns1.Add(BitBtn3);

  btns2 := TList.Create;
  btns2.Add(BitBtn4);
  btns2.Add(BitBtn5);
  btns2.Add(BitBtn6);

  arr[1].text:= 'красный';
  arr[1].color:= clRed;
  arr[2].text:= 'фиолетовый';
  arr[2].color:= clPurple;
  arr[3].text:= 'зелёный';
  arr[3].color:= clGreen;
  for z := 1 to 3 do
    begin
      i := random(btns1.Count-1);
      j := random(btns2.Count-1);

      TBitBtn(btns1[i]).Caption:=arr[z].text;
      TBitBtn(btns1[i]).Font.Color:=arr[z].color;
      TBitBtn(btns2[j]).Caption:=arr[z].text;
      TBitBtn(btns2[j]).Font.Color:=arr[z].color;

      btns1.Remove(TBitBtn(btns1[i]));
      btns2.Remove(TBitBtn(btns2[j]));
    end;
end;


end.

