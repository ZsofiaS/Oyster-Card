require 'oystercard.rb'

describe Oystercard do

  it "has a balance of zero" do
    expect(subject.balance).to eq(0)
  end

  describe "#top_up" do
    # it { is_expected.to respond_to(:top_up).with(1).argument }

    it "can top up balance" do
      expect{ subject.top_up 1 }.to change{ subject.balance }.by 1
    end
   end

   describe "#in_journey?" do
     it "is initially not in a journey" do
       expect(subject).not_to be_in_journey
     end
   end

   describe "#touch_in" do
     it "can touch in" do
       subject.top_up(15)
       subject.touch_in
       expect(subject).to be_in_journey
     end

     context "when insufficient balance" do
       it "will not touch in" do
         expect { subject.touch_in }.to raise_error "Insufficient balance to touch in"
       end
     end
   end

   describe "#touch_out" do
     it "can touch out" do
       subject.top_up(15)
       subject.touch_in
       subject.touch_out
       expect(subject).not_to be_in_journey
     end
   end

   context "when top up is required" do
     before do
       subject.top_up Oystercard::MAXIMUM_BALANCE
     end

     it 'has an upper limit' do
       error = "Maximum limit of #{Oystercard::MAXIMUM_BALANCE} reached!"
       expect { subject.top_up 1 }.to raise_error error
     end

     describe '#deduct' do
       # it { is_expected.to respond_to(:deduct).with(1).argument }
       it 'deducts an amount from the balance' do
         expect{ subject.deduct(5) }.to change{ subject.balance }.by -5
       end
     end

   end

end
