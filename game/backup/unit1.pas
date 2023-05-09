unit Unit1;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, ExtCtrls;

const BULLET_STEP = 15;
const STEP = 7;
const MAX_X = 880;
const MIN_X = 0;

const MAX_Y = 580;
const MIN_Y = 0;

type
  TPlayer = record
   img:TBitmap;
   imgSrc:string;
   x,y,hp: integer;
   widht, height:integer;
  end;

  TBullet = class
  public
   img:TBitmap;
   imgSrc:string;
   x,y: integer;
   widht, height:integer;
   isVisable: boolean;
   constructor Create(posX,posY,wid:integer; isEnemie:boolean);
  end;

  { TGame }

  TGame = class(TForm)
    Timer1: TTimer;
    EnemieSpawnTimer: TTimer;
    BotMoveTimer: TTimer;
    EnemieBulletTimer: TTimer;
    procedure BotMoveTimerExecute(Sender: TObject);
    procedure EnemieBulletTimerExecute(Sender: TObject);
    procedure EnemieSpawnTimerExecute(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormKeyPress(Sender: TObject; var Key: char);
    procedure FormMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure FormPaint(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure Timer1Timer(Sender: TObject);
  private
    procedure LoadSource();
    procedure Frame();
    procedure UpdateGame();
    procedure MoveLeft();
    procedure MoveRight();
    procedure DrawEnemies();
    procedure DrawEnemieBullets();
    procedure DrawBullets();
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
  enemie_bullets,enemies,bullets: TList;
  iSwitchWay: boolean;

implementation

{$R *.lfm}
// управление игроком
procedure TGame.FormKeyPress(Sender: TObject; var Key: char);
begin
   if key in ['a'] then MoveLeft;
   if key in ['d'] then MoveRight;
end;

// создание пуль
procedure TGame.FormMouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  bullets.Add(TBullet.Create(
    player.x,
    player.y,
    player.widht,
    false
  ));
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

// рандомная генерация противника
procedure TGame.EnemieSpawnTimerExecute(Sender: TObject);
const SPAWN_ENEMIES_COUNT = 5;
var
  i,x,y : integer;
  prints : array[0..1] of string;
begin
  prints[0] := 'assets\bot.bmp';
  prints[1] := 'assets\bot1.bmp';
  if enemies.Count = 0 then
  begin
    for i := 1 to SPAWN_ENEMIES_COUNT do
    begin
      x := random(MAX_X);
      y := random(MAX_Y - 300);
      enemies.Add(TBot.Create(
        x,
        y,
        prints[random(High(prints)+1)]
      ));
    end;
  end;
end;

// меняем направление движения противника
procedure SwitchWay();
begin
  if iSwitchWay then
  begin
    iSwitchWay := false;
  end else
  begin
    iSwitchWay := true;
  end;
end;

// перемещение противника
procedure MoveEnemie(enemie : TBot);
const STEP = 40;
begin
  if iSwitchWay then
  begin
    enemie.x := enemie.x + STEP;
  end else
  begin
    enemie.x := enemie.x - STEP;
  end;
end;

// двигаем противников
procedure TGame.BotMoveTimerExecute(Sender: TObject);
var
  i : integer;
begin
  SwitchWay();
  if enemies.Count > 0 then
  begin
    for i := 0 to enemies.Count - 1 do
    begin
      MoveEnemie(TBot(enemies[i]));
    end;
  end;
end;

// генерация пуль противника
procedure TGame.EnemieBulletTimerExecute(Sender: TObject);
var i: integer;
begin
  for i := 0 to enemies.Count - 1 do
  begin
    enemie_bullets.Add(TBullet.Create(
      TBot(enemies[i]).x,
      TBot(enemies[i]).y,
      TBot(enemies[i]).widht,
      true
    ));
  end;
end;

procedure TGame.FormPaint(Sender: TObject);
begin
  Frame();
  UpdateGame();
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

//  конструктор пули
constructor TBullet.Create(posX,posY,wid:integer; isEnemie:boolean);
begin
   img := TBitmap.Create;
   imgSrc := 'assets\bullet.bmp';
   img.LoadFromFile(imgSrc);
   x := posX + (wid div 2)-1;
   if isEnemie then y := posY+wid
   else y := posY;
   height := img.Height;
   widht := img.Width;
   isVisable := true;
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
   bullets := TList.Create;

   player.img := TBitmap.Create;
   player.imgSrc := 'assets\Player.bmp';
   player.img.LoadFromFile(player.imgSrc);
   player.x := MAX_X div 2;
   player.y := MAX_Y - 100;
   player.hp := 100;
   player.height := player.img.Height;
   player.widht := player.img.Width;

   enemie_bullets := TList.Create;

   enemies := TList.Create;
   enemies.Add(TBot.Create(100, 100, 'assets\bot.bmp'));
   enemies.Add(TBot.Create(530, 80, 'assets\bot1.bmp'));
   enemies.Add(TBot.Create(630, 90, 'assets\bot1.bmp'));
   enemies.Add(TBot.Create(800, 150, 'assets\bot.bmp'));
   enemies.Add(TBot.Create(90, 330, 'assets\bot.bmp'));
 end;

// отрисовка пуль противника
 procedure TGame.DrawEnemieBullets();
 var i : integer;
 begin
   for i := 0 to enemie_bullets.Count - 1 do begin
      if (TBullet(enemie_bullets[i]) <> nil)
      and(TBullet(enemie_bullets[i]).isVisable) then begin
        Canvas.Draw(
          TBullet(enemie_bullets[i]).x,
          TBullet(enemie_bullets[i]).y,
          TBullet(enemie_bullets[i]).img
        );
      end;
   end;
 end;

// отрисовка врагов
procedure TGame.DrawEnemies();
var i : integer;
begin
  for i := 0 to enemies.Count - 1 do begin
      if TBot(enemies[i]).isVisable then begin
        Canvas.Draw(
          TBot(enemies[i]).x,
          TBot(enemies[i]).y,
          TBot(enemies[i]).img
        );
      end;
    end;
end;

// отрисовка пуль
procedure TGame.DrawBullets();
var i : integer;
begin
  for i := 0 to bullets.Count - 1 do begin
      if (TBullet(bullets[i]) <> nil)and(TBullet(bullets[i]).isVisable) then begin
        Canvas.Draw(
          TBullet(bullets[i]).x,
          TBullet(bullets[i]).y,
          TBullet(bullets[i]).img
        );
      end;
    end;
end;

//общий вызов отрисовок
 procedure TGame.Frame();
 var
   i: integer;
 begin
    Canvas.Draw(player.x, player.y, player.img);
    DrawEnemies();
    DrawBullets();
    DrawEnemieBullets();
 end;

// механика стрельбы игрока
procedure PlayerShoot();
var i,j : integer;
begin
  // анимация полета пуль
  for i := 0 to bullets.Count - 1 do begin
    if TBullet(bullets[i]).y > MIN_Y then begin
      TBullet(bullets[i]).y := TBullet(bullets[i]).y - BULLET_STEP;
    end else begin
      bullets.Remove(TBullet(bullets[i]));
      break;
    end;
    // проверка на столкновение с ботом
    for j := 0 to enemies.Count - 1 do begin
      // регистрация попадания
      if (TBullet(bullets[i]).y < TBot(enemies[j]).y+TBot(enemies[j]).height)
      and (TBullet(bullets[i]).y > TBot(enemies[j]).y) and
      (TBullet(bullets[i]).x > TBot(enemies[j]).x) and
      (TBullet(bullets[i]).x < TBot(enemies[j]).x+TBot(enemies[j]).widht) and
      (TBullet(bullets[i]).isVisable)
      then
      begin
        TBot(enemies[j]).health := TBot(enemies[j]).health - 25;
        TBullet(bullets[i]).isVisable := false;
        if TBot(enemies[j]).health <= 0 then begin
          enemies.Remove(TBot(enemies[j]));
          break;
        end;
      end;

    end;
  end;
end;

// механика стрельбы противника
procedure EnemieShoot();
var i,j : integer;
begin
  for i := 0 to enemie_bullets.Count - 1 do
  begin
    // анимация полета
    if TBullet(enemie_bullets[i]).y < MAX_Y
    then begin
      TBullet(enemie_bullets[i]).y :=
      TBullet(enemie_bullets[i]).y + 5;
    end else
    begin
      enemie_bullets.Remove(
        TBullet(enemie_bullets[i]
      ));
      break;
    end;
    // поподание по игроку
    if (TBullet(enemie_bullets[i]).y < player.y+player.height)
      and (TBullet(enemie_bullets[i]).y > player.y) and
      (TBullet(enemie_bullets[i]).x > player.x) and
      (TBullet(enemie_bullets[i]).x < player.x+player.widht) and
      (TBullet(enemie_bullets[i]).isVisable)
    then begin
       TBullet(enemie_bullets[i]).isVisable := false;
       player.hp := player.hp - 20;
       // возраждение короч
       if player.hp <= 0 then begin
         ShowMessage('Вы проебали!');
         break;
       end;
    end;
  end;
end;

// различные обновления
procedure TGame.UpdateGame();
begin
  // стрельба игрока
  PlayerShoot();
  EnemieShoot();
end;

end.

