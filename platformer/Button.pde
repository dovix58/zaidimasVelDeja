class Button
{
  PVector Position = new PVector(0,0);
  float Width = 0;
  float Height = 0;
  color Color;
  String Text;
  Boolean Pressed = false;
  Boolean Clicked = false;
  
  Button(int x, int y, int w,int h, String t, int r, int g, int b)
  {
  
  Position.x = x;
  Position.y = y;
  Width = w;
  Height = h;
  Color = color(r,g,b);
  Text = t;
  }
  
  void update(){
    
    if(mousePressed && mouseButton == LEFT && !Pressed )
    {
    
    Pressed = true;
    if(mouseX >= Position.x && mouseX <= Position.x+Width && mouseY >= Position.y && mouseY <= Position.y+Height)
    {
    Clicked = true;
    }
    
    }else
    {
      Clicked = false;
      Pressed = false;
    }
    
    
  }
  
  void render()
{

  fill(Color);
  rect(Position.x, Position.y,Width,Height);
  
  fill(0);
  textAlign(CENTER,CENTER);
  textSize(25);
  text(Text, Position.x+(Width/2),Position.y+(Height/2));

}  
  boolean isClicked()
{
return Clicked;
}
}
