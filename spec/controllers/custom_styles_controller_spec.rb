#-- copyright
# OpenProject is a project management system.
# Copyright (C) 2012-2015 the OpenProject Foundation (OPF)
#
# This program is free software; you can redistribute it and/or
# modify it under the terms of the GNU General Public License version 3.
#
# OpenProject is a fork of ChiliProject, which is a fork of Redmine. The copyright follows:
# Copyright (C) 2006-2013 Jean-Philippe Lang
# Copyright (C) 2010-2013 the ChiliProject Team
#
# This program is free software; you can redistribute it and/or
# modify it under the terms of the GNU General Public License
# as published by the Free Software Foundation; either version 2
# of the License, or (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this program; if not, write to the Free Software
# Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA  02110-1301, USA.
#
# See doc/COPYRIGHT.rdoc for more details.
#++

require 'spec_helper'

describe CustomStylesController, type: :controller do
  let(:a_license) { License.new }

  before do
    login_as user
  end

  context 'with admin' do
    let(:user) { FactoryGirl.build(:admin) }

    describe '#show' do
      subject { get :show }
      render_views

      context 'when active license exists' do
        before do
          allow(a_license).to receive(:allows_to?).with(:define_custom_style).and_return(true)
          allow(License).to receive(:current).and_return(a_license)
        end

        it 'renders show' do
          expect(subject).to be_success
          expect(response).to render_template 'show'
        end
      end

      context 'when no active license exists' do
        before do
          allow(License).to receive(:current).and_return(nil)
        end

        it 'redirects to #upsale' do
          expect(subject).to redirect_to action: :upsale
        end
      end
    end

    describe "#upsale" do
      subject { get :upsale}
      render_views

      it 'renders upsale' do
        expect(subject).to be_success
        expect(subject).to render_template 'upsale'
      end
    end

    describe "#create" do
      let(:custom_style) { CustomStyle.new }
      let(:params) do
        {
          custom_style: { logo: 'foo' }
        }
      end

      before do
        allow(a_license).to receive(:allows_to?).with(:define_custom_style).and_return(true)
        allow(License).to receive(:current).and_return(a_license)
        allow(CustomStyle).to receive(:new).and_return(custom_style)
        expect(custom_style).to receive(:save).and_return(valid)

        # How do I test strong parameters?
        # expect(CustomStyle).to receive(:create).with(logo: "foo").and_return(valid)

        post :create, params: params
      end

      context 'valid custom_style input' do
        let(:valid) { true }

        it 'redirects to show' do
          expect(response).to redirect_to action: :show
        end
      end

      context 'invalid custom_style input' do
        let(:valid) { false }

        it 'renders with error' do
          expect(response).not_to be_redirect
          expect(response).to render_template 'custom_styles/show'
        end
      end


    end

    describe "#update" do
      pending("#update")
    end

    describe "#logo_download" do
      pending("#logo_download")
    end

    describe "#logo_download" do
      pending("#logo_downdload")
    end

  end

  context 'regular user' do
    let(:user) { FactoryGirl.build(:user) }

    before do
      get :show
    end

    it 'is forbidden' do
      expect(response.status).to eq 403
    end
  end
end