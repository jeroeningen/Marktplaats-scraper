module ApplicationHelper
  #return the current controller
  def current_controller
    controller.controller_name
  end

  #check if the given controller is the current controller
  def current_controller?(controller)
    current_controller == controller
  end

  #adds class 'active' to the link if the controller is the current controller
  def active_link?(controller)
    current_controller?(controller) ? {:class => :active} : {}
  end
  
  #create the link to scrape it and open the fancybox with a wait message
  def scraperlink_to_fancybox name
    link_to_function name, "$.fancybox({content: 'Even geduld a.u.b. De laadtijd is ca. 30 seconden.'}); $.ajax({url: '#{scraper_path("marktplaats")}', success: function(html){document.getElementsByTagName('html')[0].innerHTML = html;}})"
  end
end
