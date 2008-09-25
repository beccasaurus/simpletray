SimpleTray.app {

  "About" => lambda { alert('This app is cool') },

  "EOL Jira" => SimpleTray::Jira.new 'http://...',

  "More Info" => {

    '[cat]  this' => lambda {},
    '[frog] that' => lambda {}

  },

  "I'm Dynamic" => lambda {
    # return randomly generated ... Hash? ... children menu items
  }

}

SimpleTray.app do

  about do
    # ...
  end

  tickets do
    {}
    []
  end

end

#----------------------------

About
  { ... }

Tickets
  {
    #.
  }

#call -> do it
else ... #each
