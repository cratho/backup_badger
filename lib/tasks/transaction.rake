namespace :transaction do
  desc 'Generate transactions if not already done'
  task generate: :environment do
    Rotation.all.each(&:generate_transactions)
  end

  desc 'Process transactions'
  task process: :environment do
    Transaction.where(completed: false).each(&:process)
  end
end
