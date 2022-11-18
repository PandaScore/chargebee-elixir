defmodule ChargebeeElixir.InvoiceTest do
  use ExUnit.Case
  import Mox

  setup :verify_on_exit!

  

  describe "close" do
    def subject do
      ChargebeeElixir.Invoice.close(
        "draft_inv_abcde",
        %{
          "invoice_note" => "This is a note"
        }
      )
    end

    test "incorrect auth" do
      expect(
        ChargebeeElixir.HTTPoisonMock,
        :post!,
        fn url, data, headers ->
          assert url ==
                   "https://test-namespace.chargebee.com/api/v2/invoices/draft_inv_abcde/close"

          assert data == "invoice_note=This+is+a+note"

          assert headers == [
                   {"Authorization", "Basic dGVzdF9jaGFyZ2VlYmVlX2FwaV9rZXk6"},
                   {"Content-Type", "application/x-www-form-urlencoded"}
                 ]

          %{
            status_code: 401
          }
        end
      )

      assert_raise ChargebeeElixir.UnauthorizedError, fn ->
        subject()
      end
    end

    test "not found" do
      expect(
        ChargebeeElixir.HTTPoisonMock,
        :post!,
        fn url, data, headers ->
          assert url ==
                   "https://test-namespace.chargebee.com/api/v2/invoices/draft_inv_abcde/close"

          assert data == "invoice_note=This+is+a+note"

          assert headers == [
                   {"Authorization", "Basic dGVzdF9jaGFyZ2VlYmVlX2FwaV9rZXk6"},
                   {"Content-Type", "application/x-www-form-urlencoded"}
                 ]

          %{
            status_code: 404
          }
        end
      )

      assert_raise ChargebeeElixir.NotFoundError, fn ->
        subject()
      end
    end

    test "incorrect data" do
      expect(
        ChargebeeElixir.HTTPoisonMock,
        :post!,
        fn url, data, headers ->
          assert url ==
                   "https://test-namespace.chargebee.com/api/v2/invoices/draft_inv_abcde/close"

          assert data == "invoice_note=This+is+a+note"

          assert headers == [
                   {"Authorization", "Basic dGVzdF9jaGFyZ2VlYmVlX2FwaV9rZXk6"},
                   {"Content-Type", "application/x-www-form-urlencoded"}
                 ]

          %{
            status_code: 400,
            body: '{"message": "Unknown"}'
          }
        end
      )

      assert_raise ChargebeeElixir.InvalidRequestError, fn ->
        subject()
      end
    end

    test "correct data" do
      expect(
        ChargebeeElixir.HTTPoisonMock,
        :post!,
        fn url, data, headers ->
          assert url ==
                   "https://test-namespace.chargebee.com/api/v2/invoices/draft_inv_abcde/close"

          assert data == "invoice_note=This+is+a+note"

          assert headers == [
                   {"Authorization", "Basic dGVzdF9jaGFyZ2VlYmVlX2FwaV9rZXk6"},
                   {"Content-Type", "application/x-www-form-urlencoded"}
                 ]

          %{
            status_code: 200,
            body: '{"invoice": {"id": "abcde"}}'
          }
        end
      )

      assert subject() == %{"id" => "abcde"}
    end
  end

  describe "import_invoice" do
    def subject_import do
      ChargebeeElixir.Invoice.import_invoice(
        %{
          id: "inv-459",
          line_items: [
            %{
              amount: 2200
            }
          ]
        }
      )
    end

    test "correct data" do
      expect(
        ChargebeeElixir.HTTPoisonMock,
        :post!,
        fn (url, data, headers) ->
          assert url == "https://test-namespace.chargebee.com/api/v2/invoices/import_invoice"
          assert data == "id=inv-459&line_items[amount][0]=2200"
          assert headers == [
            {"Authorization", "Basic dGVzdF9jaGFyZ2VlYmVlX2FwaV9rZXk6"},
            {"Content-Type", "application/x-www-form-urlencoded"}
          ]
          %{
            status_code: 200,
            body: '{"invoice": {"id": "abcde"}}'
          }
        end
      )

      assert subject_import() == %{"id" => "abcde"}
    end
  end
end
