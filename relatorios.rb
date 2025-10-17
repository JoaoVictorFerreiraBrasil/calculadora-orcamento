class Relatorios
  def self.resumo_financeiro(usuario)
    receitas = usuario.transacoes.select { |t| t.tipo == :receita }
    despesas = usuario.transacoes.select { |t| t.tipo == :despesa }
    
    total_receitas = receitas.sum(&:valor)
    total_despesas = despesas.sum(&:valor)
    saldo = total_receitas - total_despesas
    
    puts "=" * 50
    puts "💰 RESUMO FINANCEIRO"
    puts "=" * 50
    puts "📥 Total de Receitas: R$ #{'%.2f' % total_receitas}"
    puts "📤 Total de Despesas: R$ #{'%.2f' % total_despesas}"
    puts "💎 Saldo: R$ #{'%.2f' % saldo}"
    
    # Situação financeira
    if saldo > 0
      puts "✅ Situação: POSITIVA 🎉"
    elsif saldo < 0
      puts "⚠️  Situação: NEGATIVA ❌"
    else
      puts "⚖️  Situação: EQUILIBRADO"
    end
  end
  
  def self.extrato(usuario)
    puts "=" * 50
    puts "📊 EXTRATO COMPLETO"
    puts "=" * 50
    
    if usuario.transacoes.empty?
      puts "📭 Nenhuma transação registrada."
      return
    end
    
    # Ordenar por data (mais recente primeiro)
    transacoes_ordenadas = usuario.transacoes.sort_by(&:data).reverse
    
    transacoes_ordenadas.each_with_index do |transacao, index|
      cor = transacao.tipo == :receita ? "🟢" : "🔴"
      tipo_texto = transacao.tipo == :receita ? 'RECEITA' : 'DESPESA'
      
      puts "#{cor} #{index + 1}. #{transacao.data}"
      puts "   📝 #{transacao.descricao}"
      puts "   🏷️  #{transacao.categoria}"
      puts "   💰 R$ #{'%.2f' % transacao.valor}"
      puts "   ──────────────────────"
    end
  end
  
  def self.gastos_por_categoria(usuario)
    despesas = usuario.transacoes.select { |t| t.tipo == :despesa }
    
    return unless despesas.any?
    
    puts "=" * 50
    puts "📈 GASTOS POR CATEGORIA"
    puts "=" * 50
    
    gastos_por_categoria = {}
    despesas.each do |despesa|
      gastos_por_categoria[despesa.categoria] ||= 0
      gastos_por_categoria[despesa.categoria] += despesa.valor
    end
    
    total_despesas = despesas.sum(&:valor)
    
    gastos_por_categoria.sort_by { |cat, valor| -valor }.each do |categoria, valor|
      percentual = (valor / total_despesas * 100).round(1)
      puts "  #{categoria}: R$ #{'%.2f' % valor} (#{percentual}%)"
    end
  end
end