class Usuario
  attr_accessor :nome, :email, :transacoes
  
  def initialize(nome, email)
    @nome = nome
    @email = email
    @transacoes = []
  end
  
  def adicionar_transacao(transacao)
    @transacoes << transacao
  end
  
  def remover_transacao(index)
    @transacoes.delete_at(index) if index.between?(0, @transacoes.size - 1)
  end
  
  def saldo
    receitas = @transacoes.select { |t| t.tipo == :receita }.sum(&:valor)
    despesas = @transacoes.select { |t| t.tipo == :despesa }.sum(&:valor)
    receitas - despesas
  end
  
  def to_hash
    {
      nome: @nome,
      email: @email,
      transacoes: @transacoes.map(&:to_hash)
    }
  end
  
  def self.from_hash(hash)
    usuario = Usuario.new(hash['nome'], hash['email'])
    hash['transacoes'].each do |transacao_hash|
      usuario.adicionar_transacao(Transacao.from_hash(transacao_hash))
    end
    usuario
  end
end