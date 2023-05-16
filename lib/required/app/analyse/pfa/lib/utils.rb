



unless self.respond_to?(:erreur)

  def erreur(err)
    puts "ERREUR: #{err}".rouge
  end

end
