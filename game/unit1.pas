unit Unit1;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, ExtCtrls;

const STEP = 7;
const MAX_X = 880;
const MIN_X = 0;

const MAX_Y = 580;
const MIN_Y = 0;

type
  TPlayer = record
   img:TBitmap;
   imgSrc:string;
   x,y: integer;
   widht, height:integer;
  end;

  { TGame }

  TGame = class(TForm)
    Timer1: TTimer;
    procedure FormCreate(Sender: TObject);
    procedure FormKeyPress(Sender: TObject; var Key: char);
    procedure FormPaint(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure Timer1Timer(Sender: TObject);
  private
    procedure LoadSource();
    procedure Frame();
    procedure UpdateGame();
    procedure MoveLeft();
    procedure MoveRight();
  public

  end;

  TBot = class
  public
   img:TBitmap;
   imgSrc:string;
   x,y: integer;
   widht, height:integer;
   isVisable: boolean;
   health: integer;
   constructor Create(posX, posY:integer; imgPath: string);
  end;

var
  Game: TGame;
  player: TPlayer;
  enemies: TList;

implementation

{$R *.lfm}
// управление игроком
procedure TGame.FormKeyPress(Sender: TObject; var Key: char);
begin
   if key in ['a'] then MoveLeft;
   if key in ['d'] then MoveRight;
end;

// запрет на изменение размеров формы
procedure TGame.FormCreate(Sender: TObject);
begin
  with Self, Constraints do begin
    MaxHeight:= Height;
    MinHeight:= Height;
    MaxWidth:= Width;
    MinWidth:= Width;
  end;
end;

procedure TGame.FormPaint(Sender: TObject);
begin
  Frame();
end;

procedure TGame.FormShow(Sender: TObject);
begin
  LoadSource();
end;

// конструктор бота
constructor TBot.Create(posX, posY:integer; imgPath: string);
begin
   img := TBitmap.Create;
   imgSrc := imgPath;
   img.LoadFromFile(imgSrc);
   x := posX;
   y := posY;
   height := img.Height;
   widht := img.Width;
   isVisable := true;
   health := 100;
end;

// переотрисовку в отдельный поток
procedure TGame.Timer1Timer(Sender: TObject);
begin
  Repaint();
end;

// перемещение игрока начало
procedure TGame.MoveLeft();
begin
  if player.x > MIN_X then begin
    player.x := player.x - STEP;
  end;
end;

procedure TGame.MoveRight();
begin
  if player.x < MAX_X then begin
    player.x := player.x + STEP;
  end;
end;
// конец

// загрузка игрока и врагов
 procedure TGame.LoadSource();
 begin
   player.img := TBitmap.Create;
   player.imgSrc := 'assets\Player.bmp';
   player.img.LoadFromFile(player.imgSrc);
   player.x := MAX_X div 2;
   player.y := MAX_Y;
   player.height := player.img.Height;
   player.widht := player.img.Width;

   enemies := TList.Create;
   enemies.Add(TBot.Create(100, 100, 'assets\bot.bmp'));
   enemies.Add(TBot.Create(530, 80, 'assets\bot1.bmp'));
   enemies.Add(TBot.Create(800, 150, 'assets\bot.bmp'));
 end;

// отрисовка игрока и врагов
 procedure TGame.Frame();
 var
   i: integer;
 begin
    Canvas.Draw(player.x, player.y, player.img);

    for i := 0 to enemies.Count - 1 do begin
      Canvas.Draw(
        TBot(enemies[i]).x,
        TBot(enemies[i]).y,
        TBot(enemies[i]).img
      );
    end;
 end;

 procedure TGame.UpdateGame();
 begin

 end;
end.

