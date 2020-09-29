module Grammar
  def is_or_are(amount)
    amount == 1 ? 'is' : 'are'
  end

  def no_or_number(amount)
    amount.zero? ? 'no' : amount
  end
end
