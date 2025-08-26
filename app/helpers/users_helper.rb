module UsersHelper
  def cargo_color(cargo)
    case cargo
    when 'administrador'
      'purple'
    when 'tecnico'
      'blue'
    when 'comercial'
      'green'
    when 'administrativo'
      'orange'
    else
      'gray'
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
