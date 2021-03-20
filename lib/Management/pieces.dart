  class MyPiece{
    List<List<bool>> content;

    MyPiece(List<List<bool>> content){
      this.content = content;
    }
  }
  
  final List<List<List<bool>>> pieces = [

    //  #

    [
      [true]
    ],

    //  #
    //  #

    [
      [true],
      [true]
    ],

    //  #
    //  #
    //  #

    [
      [true],
      [true],
      [true]
    ],

    //  #
    //  #
    //  #
    //  #

    [
      [true],
      [true],
      [true],
      [true]
    ],

    //  #
    //  #
    //  #
    //  #
    //  #

    [
      [true],
      [true],
      [true],
      [true],
      [true]
    ],

    //  ##

    [
      [true,true],
    ],

    //  ###

    [
      [true,true,true],
    ],
    
    //  ####

    [
      [true,true,true,true],
    ],

    //  #####

    [
      [true,true,true,true,true],
    ],

    //  ##
    //  ##

    [
      [true,true],
      [true,true]
    ],

    //  ##
    //   #

    [
      [false,true],
      [true,true]
    ],

    //  #
    //  ##

    [
      [true,false],
      [true,true]
    ],

    //  ##
    //   #

    [
      [true,true],
      [false,true]
    ],

    //  ##
    //  #

    [
      [true,true],
      [true,false]
    ],

    //    #
    //    #
    //  ###

    [
      [false,false,true],
      [false,false,true],
      [true,true,true]
    ],

    //  #
    //  #
    //  ###

    [
      [true,false,false],
      [true,false,false],
      [true,true,true]
    ],

    //  ###
    //    #
    //    #

    [
      [true,true,true],
      [false,false,true],
      [false,false,true]
    ],

    //  ###
    //  #
    //  #

    [
      [true,true,true],
      [true,false,false],
      [true,false,false]
    ],

    //   #
    //  ###

    [
      [false,true,false],
      [true,true,true]
    ],

    //  ###
    //   #

    [
      [true,true,true],
      [false,true,false],
    ],

    //  #
    //  ##
    //  #

    [
      [true,false],
      [true,true],
      [true,false]
    ],

    //   #
    //  ##
    //   #

    [
      [false,true],
      [true,true],
      [false,true]
    ],

    //   #
    //   #
    //  ###

    [
      [false,true,false],
      [false,true,false],
      [true,true,true]
    ],

    //  ###
    //   #
    //   #

    [
      [true,true,true],
      [false,true,false],
      [false,true,false],
    ],

    //  #
    //  ###
    //  #

    [
      [true,false,false],
      [true,true,true],
      [true,false,false]
    ],

    //    #
    //  ###
    //    #

    [
      [false,false,true],
      [true,true,true],
      [false,false,true]
    ],

    //  #
    //   #

    [
      [true,false],
      [false,true]
    ],

    //   #
    //  #

    [
      [false,true],
      [true,false]
    ],

    //    #
    //   #
    //  #

    [
      [false,false,true],
      [false,true,false],
      [true,false,false]
    ],

    //  #
    //   #
    //    #

    [
      [true,false,false],
      [false,true,false],
      [false,false,true]
    ],

    //  #
    //  ###

    [
      [true,false,false],
      [true,true,true]
    ],

    //  ###
    //    #

    [
      [true,true,true],
      [false,false,true],
    ],

    //  ###
    //  #

    [
      
      [true,true,true],
      [true,false,false],
    ],

    //    #
    //  ###
    

    [
      [false,false,true],
      [true,true,true],
    ],

    //  ##
    //  #   
    //  #

    [
      [true,true],
      [true,false],
      [true,false]
    ],

    //   #
    //   #
    //  ##

    [
      [false,true],
      [false,true],
      [true,true],
    ],

    //  ##
    //   #   
    //   #

    [
      [true,true],
      [false,true],
      [false,true],
    ],

    //  #
    //  #
    //  ##

    [
      [true,false],
      [true,false],
      [true,true],
    ],

    //   #
    //  ###
    //   #
    

    [
      [false,true,false],
      [true,true,true],
      [false,true,false],
    ],

    //  ##
    //  #
    //  ##
    

    [
      [true,true,],
      [true,false,],
      [true,true,],
    ],

    //  ##
    //   #
    //  ##
    

    [
      [true,true,],
      [false,true,],
      [true,true,],
    ],

    //  # #
    //  ###
    

    [
      [true,false,true,],
      [true,true,true],
    ],

    //  ###
    //  # #
    

    [
      [true,true,true],
      [true,false,true,],
    ],

    //   #
    //  ##
    //  #
    

    [
      [false,true,],
      [true,true,],
      [true,false,],
    ],

    //  #
    //  ##
    //   #
    

    [
      [true,false,],
      [true,true,],
      [false,true,],
    ],

    //   ##
    //  ##
    

    [
      [false,true,true,],
      [true,true,false],
    ],

    //  ##
    //   ##
    

    [
      [true,true,false],
      [false,true,true,],
    ],




  ];