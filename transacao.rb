class Transacao
  attr_accessor :descricao, :valor, :tipo, :categoria, :data
  
  def initialize(descricao, valor, tipo, categoria, data = Time.now)
    @descricao = descricao
    @valor = valor
    @tipo = tipo # :receita ou :despesa
    @categoria = categoria
    @data = data
  end
  
  def to_hash
    {
      descricao: @descricao,
      valor: @valor,
      tipo: @tipo,
      categoria: @categoria,
      data: @data.strftime("%d/%m/%Y %H:%M")
    }
  end
  
  def self.from_hash(hash)
    Transacao.new(
      hash['descricao'],
      hash['valor'],
      hash['tipo'].to_sym,
      hash['categoria'],
      Time.parse(hash['data'])
    )
  end
end