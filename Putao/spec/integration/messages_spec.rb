require 'putao'

describe Putao do
  it 'gets a page of messages' do
    p = Putao.new(passkey: ENV['PASSKEY'], user_id: ENV['USER_ID'].to_i)
    expect(p).to be_a(Putao)
    expect(p.messages.a_page).to include(a_kind_of(Putao::Message))
    expect(p.messages.a_page_matching('咱@您了~')).to include(a_kind_of(Putao::Message))
  end
end
