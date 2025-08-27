module ApplicationHelper
  def nav_link_classes(controller_name_to_check)
    base_classes = "flex items-center space-x-2 px-4 py-2 rounded-lg text-sm font-medium transition-colors duration-200"
    
    if controller_name == controller_name_to_check
      "#{base_classes} text-blue-700 bg-blue-50 hover:bg-blue-100 border-l-4 border-blue-600"
    else
      "#{base_classes} text-gray-600 hover:text-blue-700 hover:bg-gray-50"
    end
  end
  
  def mobile_nav_link_classes(controller_name_to_check)
    base_classes = "flex items-center space-x-3 px-3 py-2 rounded-md text-sm font-medium transition-colors duration-200"
    
    if controller_name == controller_name_to_check
      "#{base_classes} text-blue-700 bg-blue-100 border-l-4 border-blue-600"
    else
      "#{base_classes} text-gray-600 hover:text-gray-900 hover:bg-gray-100"
    end
  end

  
  def cargo_color(cargo)
    case cargo
    when 'administrador'
      'bg-purple-100 text-purple-800'
    when 'tecnico'
      'bg-blue-100 text-blue-800'
    when 'comercial'
      'bg-green-100 text-green-800'
    when 'administrativo'
      'bg-orange-100 text-orange-800'
    else
      'bg-gray-100 text-gray-800'
    end
  end

  def cargo_icon(cargo)
    case cargo
    when 'administrador'
      '👑'
    when 'tecnico'
      '🔧'
    when 'comercial'
      '💼'
    when 'administrativo'
      '📊'
    else
      '👤'
    end
  end
end
