//Defines an environment of gui controls--so that we can switch between environments
class Window {
  ArrayList<Button> buttons;
  ArrayList<Label> labels;
  ArrayList<Image> images;
  
  //Add a button through button constructor
  void addButton(float x, float y, float Width, float Height, String name, String text, int textSize) {
      buttons.add(new Button(x, y, Width, Height, name, text, textSize));
  }
  //Remove a button by checking against text
  void removeButton(String name) {
      for(int i = 0; i < buttons.size(); i++) {
        if(buttons.get(i).name==name) {
          buttons.remove(i);
          return;
        }
      }
  }
  //Add a label through label constructor
  void addLabel(float x, float y, float Width, float Height, String name, String text, int textSize) {
    labels.add(new Label(x, y, Width, Height, name, text, textSize));
  }
  //Remove a label by checking against text
  void removeLabel(String name) {
      for(int i = 0; i < labels.size(); i++) {
        if(labels.get(i).name==name) {
          labels.remove(i);
          return;
        }
      }
  }
  //Add an image through imgSource
  void addImage(String imgSource, String name, int x, int y) {
     PImage img = new PImage();
     img = loadImage(imgSource);
     images.add(new Image(img, name, x, y)); 
  }
  //Calculates the hover state of each button
  void handleMouseHover() {
    for(int i = 0; i < buttons.size(); i++) {
      if(buttons.get(i).isInBounds(mouseX, mouseY)) {
        buttons.get(i).hoverState = true; 
      }
      else {
        buttons.get(i).hoverState = false; 
      }
    }
  }
  //Handles a mouse click passed by the mousePressed main event handler
  void handleMouseClick() {
    for(int i = 0; i < buttons.size(); i++) {
      if(buttons.get(i).isInBounds(mouseX, mouseY)) {
        println("Button " + buttons.get(i).name + " was clicked.");
        globalButtonHandler(buttons.get(i).name);
      }
    }
  }
  //Render all window components
  void render() {
    handleMouseHover(); //Should always check hover states before rendering
     for(int i = 0; i < buttons.size(); i++) {
       buttons.get(i).render();
     }
     for(int i = 0; i < labels.size(); i++) {
       labels.get(i).render();
     }
     for(int i = 0; i < images.size(); i++) {
       images.get(i).render();
     }
  }
  
  Window() {
    buttons = new ArrayList<Button>();
    labels = new ArrayList<Label>();
    images = new ArrayList<Image>();
  }
}
