program snacePrototype;
uses crt;
const
	top = -72;
	right = -77;
	buttom = -80;
	left = -75;
	speed = 50;
type
	CoorXY = record
		x, y:integer;
	end;
var
	F:text;
	Snake:array [1..10000] of CoorXY;
	Tail:array[2..10000] of CoorXY;
	Rec,RT,Key,Step,i,MSn,LengthSnake,Ratio,CoorX,CoorY,ScreenW,ScreenH:integer;
	Food:CoorXY;
	SkinSnake,SkinFood,SkinWalls:char;
	GameOver,PosSnake,NewRecord:boolean;
	EndOver,Victory:string;
{'F' RANDOMFOOD}
function randFood(w, h:integer):CoorXY;
var
	Food:CoorXY;
begin
	Food.x := random(w - 3 * 2) + 4;
	Food.y := random(h - 2 * 2) + 3;

	randFood := Food;
end;
{INITIALITE VAR}
procedure Initialize;
begin
	RT := TextAttr;
	Step := 5;
	EndOver := '------ Game Over ------';
	Victory := '****** VICTORY ******';
	ScreenW := ScreenWidth;
	ScreenH := ScreenHeight;
	Ratio := ScreenW div ScreenH;
	Food := randFood(ScreenW, ScreenH); 
	GameOver := false;
	CoorX := ScreenW div 2;
	CoorY := ScreenH div 2;
	LengthSnake := 1;
	for i := 2 to LengthSnake do begin
		Tail[i].x := CoorX;
		Tail[i].y := CoorY;
	end;
	Key := ord('w');
	SkinSnake := ' ';
	SkinFood := ' ';
	SkinWalls := ' ';
end;
{KEY}
procedure GetKey;
var 
	ch:char;
begin
	ch := Readkey;
	if ch = #0 then begin
		ch := ReadKey;
		key := -ord(ch);
	end
	else
		key := ord(ch);
end;
{DRAWFOOD}
procedure DrawFood;
begin
	TextBackground(LightRed);{COLOR FOOD}
	GotoXY(Food.x, Food.y);
	write(SkinFood);	
end;
{EATFOOD}
procedure EatFood;
begin
	if (Snake[1].x = Food.x)and
	   (Snake[1].y = Food.y) then begin
		  GotoXY(Food.x, Food.y);
		  write(' ');
		  LengthSnake := LengthSnake + Step;
		repeat
			Food := randFood(ScreenW, ScreenH);
			PosSnake := true;
			for i := 1 to LengthSnake do begin
				if (Snake[i].x = Food.x)and
				   (Snake[i].y = Food.y)then
					PosSnake := false;
			end;	
		until PosSnake;
	end;
end;
{DRAW SNAKE}
procedure DrawSnake;
begin
	Textbackground(Green);{COLOR SNAKE}
	Snake[1].x := CoorX;
	Snake[1].y := CoorY;
	for i := 2 to LengthSnake do begin
		Snake[i].x := Tail[i].x;
		Snake[i].y := Tail[i].y;
	end;
	for i := 1 to lengthSnake do begin
		GotoXY(Snake[i].x, Snake[i].y);
		write(SkinSnake);
	end;
	GotoXY(1,1);
end;
{DRAW WALLS}
procedure DrawWalls;
begin
	TextBackground(White);{COLOR WALLS}
	for i := 4 to ScreenW - 3 do begin
		GotoXY(i, 2);
		write(SkinWalls);
		GotoXY(i, ScreenH - 1);
		write(SkinWalls);
	end;
	for i := 3 to ScreenH - 2 do begin
		GotoXY(3, i);
	       	write(SkinWalls);
		GotoXY(ScreenW - 2, i);
		write(SkinWalls);
	end;	
	TextBackground(Black);{COLOR BACKGROUND}
end;
{SPEED GAME}
procedure SpeedGame(speed:integer);
begin
	if ((Key = ord('a'))or(Key = ord('d')))or((Key = -77)or(Key = -75)) then
		delay(speed div Ratio)
	else
		delay(speed);

end;
{UPDATE SNAKE}
procedure UpdateSnake;
begin
	for i := 2 to LengthSnake do begin
		Tail[i].x := Snake[i - 1].x;
		Tail[i].y := snake[i - 1].y;
	end;
end;
{MOVE}
procedure Movement;
begin
	if(MSn = top) and ((Key = ord('s')) or (Key = buttom))then
		Key := ord('w')
	else if(MSn = right) and ((Key = ord('a')) or (Key = left))then
		Key := ord('d')
	else if(MSn = buttom) and ((Key = ord('w')) or (Key = top))then
		Key := ord('s')
	else if(MSn = left) and ((Key = ord('d'))or(Key = right))then
		Key := ord('a'); 
		
	case Key of
		ord('w'),top: MSn := top;
		ord('d'),right: Msn := right;
		ord('s'),buttom: MSn := buttom;
		ord('a'),left: Msn := left;
	end;
	case MSn of
		top: CoorY := CoorY - 1;
		right: CoorX := CoorX + 1;
		buttom: CoorY := CoorY + 1;
		left: CoorX := CoorX - 1;
	end;
end;
{BORDERS}
procedure Borders;
begin
	if CoorX < 4 then
		CoorX := ScreenW - 3
	else if CoorX > ScreenW - 3 then
		CoorX := 4
	else if CoorY < 3 then
		CoorY := ScreenH - 2
	else if CoorY > ScreenH - 2 then begin
		CoorY := 3;
	end;
end;
{OVER}
procedure Over;
begin
	for i := 2 to LengthSnake do begin
		if (Snake[1].x = Snake[i].x)and
		   (Snake[1].y = Snake[i].y) then
			GameOver := true;
	end;
end;
{NEW RECORD}
procedure NewRec;
var
	number:integer;
begin
	{$I-}
	number := 0;
	assign(F, 'RecordCoin.txt');
	reset(F);
	if IOResult <> 0 then begin
		rewrite(F);
		write(F, number);
	end;
	
	close(F);
	reset(F);
	read(F, number);
	if IOResult <> 0 then begin
		rewrite (F);
		write(F, number);
	end;
	{$I+}
	close(F);
	if (LengthSnake - 1 > number) and (number > 0) then begin
		rewrite(F);
		write(F, LengthSnake);
		NewRecord := true;
		close(F);
		Rec := LengthSnake - 1;
	end
	else if number = 0 then begin
		rewrite(F);
		write(F, LengthSnake - 1);
		close(F);
		NewRecord := false;
		Rec := LengthSnake - 1;
	end
	else begin
		NewRecord := false;
		Rec := LengthSnake - 1;
	end;
end;
{MESSAGE}
procedure Message(Msg:string);
begin
	GotoXY((ScreenW div 2)-(length(Msg) div 2), ScreenH div 2);
	write(Msg);
	GotoXY((ScreenW div 2)-(length(Msg) div 2) + 7, ScreenH div 2 + 1);
	NewRec;
	write('You Eat ', (Rec) div Step, ' ');
	if NewRecord then
		TextColor(Yellow);
		write('RECORD ');
	if LengthSnake >= 1000 then begin
 		GotoXY((ScreenW div 2)-(length(Msg) div 2) + 7, ScreenH div 2 + 2);
		write('Reward ');
		for i:= 1 to (LengthSnake - 1) div 1000 do
			write('*');
	end;
end;
{MAIN}
begin
	randomize;
	clrscr;
	Initialize;
	repeat
		if KeyPressed then
			GetKey;
		DrawFood;
		EatFood;
		DrawSnake;
		TextBackground(Blue);{COLOR SCORE}
		write('Eat: ', (LengthSnake - 1) div Step);
		DrawWalls;
		UpdateSnake;
		Movement;
		Borders;
		Over;
		SpeedGame(speed);
		clrscr;
	until (GameOver)or(lengthSnake >= (ScreenW - 6) * (ScreenH - 4));
		if(lengthSnake >= (ScreenW - 6) * (ScreenH - 4)) then begin
			TextColor(Yellow);{COLOR VICTORY}
			Message(Victory);
		end
		else begin
			TextColor(Red);{COLOR GAME OVER}
			Message(EndOver);
		end;
		delay(5000);
		TextAttr := RT;
		clrscr;
end.
