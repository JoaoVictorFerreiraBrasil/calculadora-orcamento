require 'json'
require_relative 'transacao'
require_relative 'usuario'
require_relative 'relatorios'

class CalculadoraOrcamento
  def initialize
    @usuario = nil
    @categorias = ['Salário', 'Alimentação', 'Transporte', 'Moradia', 'Lazer', 'Saúde', 'Educação', 'Outros']
    carregar_dados
  end
  
  def menu_principal
    loop do
      system "cls" || system("clear")
      mostrar_titulo
      
      if @usuario.nil?
        menu_boas_vindas
      else
        menu_usuario
      end
    end
  end
  
  private
  
  def menu_boas_vindas
    puts "1. 👤 Criar Novo Usuário"
    puts "2. 📂 Carregar Usuário Existente"
    puts "3. 🚪 Sair"
    puts "=" * 50
    print "Escolha uma opção: "
    
    case gets.chomp.to_i
    when 1 then criar_usuario
    when 2 then carregar_usuario
    when 3 then salvar_e_sair
    else puts "❌ Opção inválida!"; sleep(1)
    end
  end
  
  def menu_usuario
    puts "1. 📥 Adicionar Receita"
    puts "2. 📤 Adicionar Despesa"
    puts "3. 📊 Ver Extrato Completo"
    puts "4. 💰 Ver Resumo Financeiro"
    puts "5. 📈 Gastos por Categoria"
    puts "6. 🏷️  Gerenciar Categorias"
    puts "7. 💾 Salvar e Sair"
    puts "=" * 50
    print "Escolha uma opção: "
    
    case gets.chomp.to_i
    when 1 then adicionar_transacao(:receita)
    when 2 then adicionar_transacao(:despesa)
    when 3 then Relatorios.extrato(@usuario)
    when 4 then Relatorios.resumo_financeiro(@usuario)
    when 5 then Relatorios.gastos_por_categoria(@usuario)
    when 6 then gerenciar_categorias
    when 7 then salvar_e_sair
    else puts "❌ Opção inválida!"; sleep(1)
    end
    
    puts "\nPressione Enter para continuar..."
    gets
  end
  
  def criar_usuario
    system "cls" || system("clear")
    puts "=" * 50
    puts "👤 CRIAR NOVO USUÁRIO"
    puts "=" * 50
    
    print "Nome: "
    nome = gets.chomp
    print "Email: "
    email = gets.chomp
    
    @usuario = Usuario.new(nome, email)
    puts "✅ Usuário criado com sucesso!"
    sleep(1)
  end
  
  def adicionar_transacao(tipo)
    system "cls" || system("clear")
    puts "=" * 50
    puts "📝 NOVA #{tipo.to_s.upcase}"
    puts "=" * 50
    
    print "Descrição: "
    descricao = gets.chomp
    
    print "Valor: R$ "
    valor = gets.chomp.to_f
    
    puts "\n📂 Categorias disponíveis:"
    @categorias.each_with_index { |cat, i| puts "  #{i+1}. #{cat}" }
    print "Escolha a categoria (1-#{@categorias.size}): "
    categoria_idx = gets.chomp.to_i - 1
    
    if categoria_idx.between?(0, @categorias.size-1)
      categoria = @categorias[categoria_idx]
    else
      categoria = "Outros"
    end
    
    transacao = Transacao.new(descricao, valor, tipo, categoria)
    @usuario.adicionar_transacao(transacao)
    
    puts "\n✅ #{tipo.capitalize} adicionada com sucesso!"
  end
  
  def gerenciar_categorias
    system "cls" || system("clear")
    puts "=" * 50
    puts "🏷️  GERENCIAR CATEGORIAS"
    puts "=" * 50
    
    puts "Categorias atuais:"
    @categorias.each_with_index { |cat, i| puts "  #{i+1}. #{cat}" }
    
    puts "\n1. ➕ Adicionar categoria"
    puts "2. 🔙 Voltar"
    print "Escolha: "
    
    case gets.chomp.to_i
    when 1
      print "Nova categoria: "
      nova_categoria = gets.chomp
      if nova_categoria.strip != "" && !@categorias.include?(nova_categoria)
        @categorias << nova_categoria
        puts "✅ Categoria adicionada!"
      else
        puts "❌ Categoria inválida ou já existe!"
      end
    end
  end
  
  def mostrar_titulo
    puts "=" * 50
    puts "💰 CALCULADORA DE ORÇAMENTO PESSOAL"
    puts "=" * 50
    
    if @usuario
      puts "👤 Usuário: #{@usuario.nome}"
      puts "📊 Total de transações: #{@usuario.transacoes.size}"
      
      saldo = @usuario.saldo
      cor_saldo = saldo >= 0 ? "🟢" : "🔴"
      puts "#{cor_saldo} Saldo atual: R$ #{'%.2f' % saldo}"
    else
      puts "Bem-vindo! Crie ou carregue um usuário para começar."
    end
    puts "=" * 50
  end
  
  def carregar_dados
    return unless File.exist?('dados.json')
    
    begin
      dados = JSON.parse(File.read('dados.json'))
      @usuario = Usuario.from_hash(dados['usuario']) if dados['usuario']
      @categorias = dados['categorias'] if dados['categorias']
      puts "✅ Dados carregados!"
    rescue => e
      puts "❌ Erro ao carregar dados: #{e.message}"
    end
  end
  
  def carregar_usuario
    # Para múltiplos usuários no futuro
    carregar_dados
  end
  
  def salvar_e_sair
    if @usuario
      dados = {
        usuario: @usuario.to_hash,
        categorias: @categorias
      }
      
      File.write('dados.json', JSON.pretty_generate(dados))
      puts "✅ Dados salvos com sucesso!"
    end
    
    puts "👋 Até logo!"
    exit
  end
end

# Iniciar a calculadora
puts "🚀 Iniciando Calculadora de Orçamento..."
calculadora = CalculadoraOrcamento.new
calculadora.menu_principal