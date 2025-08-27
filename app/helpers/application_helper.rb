module ApplicationHelper
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
