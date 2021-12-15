static ArrayList<Integer> milestoneHeights = new ArrayList<Integer>();
static ArrayList<String> milestones = new ArrayList<String>();

static void initMilestones() {
  milestoneHeights.add(0);
  milestones.add("Sea Level");
  milestoneHeights.add(828);
  milestones.add("Burj Khalifa");
  milestoneHeights.add(8849);
  milestones.add("Mt Everest");
  milestoneHeights.add(10000);
  milestones.add("Troposphere");
  milestoneHeights.add(18000);
  milestones.add("Stratosphere");
  milestoneHeights.add(48000);
  milestones.add("Ionosphere");
  milestoneHeights.add(70000);
  milestones.add("Karman Line (space!)");
  milestoneHeights.add(408773);
  milestones.add("International Space Station");
  milestoneHeights.add(384472282);
  milestones.add("The Moon");
}


static String getCurrentMilestone(int meters) {
  String milestone = "";
  int milestoneHeight = 0;
  for(int i = 0; i < milestoneHeights.size(); i++) {
    if(meters >= milestoneHeights.get(i)) {
      milestone = milestones.get(i);
      milestoneHeight = milestoneHeights.get(i);
    }
    else {
      return milestone + ", " + milestoneHeight + " m";
    }
  }
  return "";
}

static String getNextMilestone(int meters) {
  for(int i = 0; i < milestoneHeights.size(); i++) {
    if(meters < milestoneHeights.get(i)) {
      return milestones.get(i) + ", " + milestoneHeights.get(i) + " m";
    }
  }
  return "";
}
