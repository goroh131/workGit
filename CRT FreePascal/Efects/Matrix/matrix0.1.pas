program matrix;
uses
	crt;
type
	XY = record
		x,y:integer;
	end;
	ObjectXY = record
		symbol:char;
		coordinates:XY;
	end;
var
	res:integer;
	data:array[1..150]of ObjectXY;
{INITIALIZE}
procedure Initialize;
var
	i:integer;
begin
	for i := 1 to length(data) do begin
		data[i].symbol := chr(33 + random(90));
		data[i].coordinates.x := i;
		data[i].coordinates.y := 1 + random(ScreenHeight);
	end;
end;
procedure Speed(var src:integer; sp:integer);
begin
	src := src + sp;
end;
{DRAW}
procedure Draw(ch:char; x,y:integer; color:byte);
begin
	GotoXY(x, y);
	TextColor(color);
	write(ch);

end;
{DRAW FRAME}
procedure DrawFrame;
var
	i:integer;
begin
	for i := 1 to length(data) do begin
		if (data[i].coordinates.y >= 1) and
	           (data[i].coordinates.y <= ScreenHeight) then
			Draw(data[i].symbol, data[i].coordinates.x, data[i].coordinates.y, LightGreen);

		if (data[i].coordinates.y > 1) and
	       	   (data[i].coordinates.y <= ScreenHeight + 1) then
			Draw(data[i].symbol, data[i].coordinates.x, data[i].coordinates.y - 1, Green);

		if (data[i].coordinates.y > 2) and
	           (data[i].coordinates.y <= ScreenHeight + 2) then
			Draw(data[i].symbol, data[i].coordinates.x, data[i].coordinates.y - 2, DarkGray);
	end;
	delay(50);
	clrscr;
	for i := 1 to length(data) do begin
		if (Random(100) > 90) and (data[i].coordinates.y < ScreenHeight - 3)then
			Speed(data[i].coordinates.y, 3)
		else
			Speed(data[i].coordinates.y, 1);
		if random(100) > 70 then
			data[i].symbol := chr(33 + random(90));
		if data[i].coordinates.y > ScreenHeight + 2 then begin
			data[i].coordinates.y := 1;
			data[i].symbol := chr(33 + random(90));
		end;
	end;
end;
{MAIN}
begin
	res := textattr;
	randomize;
	clrscr;
	Initialize;
	while not KeyPressed do begin
		DrawFrame;
	end;
	textattr := res;	
	clrscr;
end.
