# frozen_string_literal: true

shared_examples 'voted' do
  let(:user)       { create(:user) }
  let(:model)      { create(described_class.controller_name.classify.underscore.to_sym) }
  let(:parameters) { { id: model.id, format: :json } }

  describe 'PATCH #vote_up' do
    subject { patch :vote_up, params: parameters }

    describe 'Authorized user' do
      before { login(user) }

      context 'not author the resource' do
        it 'can vote up' do
          expect { subject }.to change(model.votes, :count).by(1)
        end

        it 'can not vote twice' do
          subject
          subject
          expect(model.evaluation).to eq 1
        end

        it 'can un vote' do
          model.votes.create(user: user, value: 1)
          expect { subject }.to change(model.votes, :count).by(0)
        end
      end

      context 'author the resource' do
        before { model.update(author_id: user.id) }

        it 'can not vote up' do
          expect { subject }.to_not change(model.votes, :count)
        end
      end
    end

    describe 'Unauthorized user' do
      it 'can not vote up' do
        expect { subject }.to_not change(model.votes, :count)
      end

      it 'get 401 status Unauthorized' do
        expect(subject).to have_http_status(401)
      end
    end
  end

  describe 'PATCH #vote_down' do
    subject { patch :vote_down, params: parameters }

    describe 'Authorized user' do
      before { login(user) }

      context 'not author the resource' do
        it 'can vote down' do
          expect { subject }.to change(model.votes, :count).by(1)
        end

        it 'can not vote twice' do
          subject
          subject
          expect(model.evaluation).to eq(-1)
        end

        it 'can un vote' do
          model.votes.create(user: user, value: -1)
          expect { subject }.to change(model.votes, :count).by(0)
        end
      end

      context 'author the resource' do
        before { model.update(author_id: user.id) }

        it 'can not vote down' do
          expect { subject }.to_not change(model.votes, :count)
        end
      end
    end

    describe 'Unauthorized user' do
      it 'can not vote down' do
        expect { subject }.to_not change(model.votes, :count)
      end

      it 'get 401 status Unauthorized' do
        expect(subject).to have_http_status(401)
      end
    end
  end
end
