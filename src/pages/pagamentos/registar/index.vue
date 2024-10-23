<script setup>
import InvoiceEditable from "@/views/pagamentos/InvoiceEditable.vue";
import InvoiceSendInvoiceDrawer from "@/views/pagamentos/InvoiceSendInvoiceDrawer.vue";

// 👉 Default Blank Data
const invoiceData = ref({
  invoice: {
    id: 5037,
    issuedDate: "",
    service: "",
    total: 0,
    avatar: "",
    invoiceStatus: "",
    dueDate: "",
    balance: 0,
    client: {
      address: "112, Lorem Ipsum, Florida",
      company: "Greeva Inc",
      companyEmail: "johndoe@greeva.com",
      contact: "+1 123 3452 12",
      country: "USA",
      name: "John Doe",
    },
  },
  paymentDetails: {
    totalDue: "$12,110.55",
    bankName: "American Bank",
    country: "United States",
    iban: "ETD95476213",
    swiftCode: "BR91905",
  },
  purchasedProducts: [
    {
      title: "",
      cost: 0,
      hours: 0,
      description: "",
    },
  ],
  note: "",
  paymentMethod: "",
  salesperson: "",
  thanksNote: "",
});



const isSendPaymentSidebarVisible = ref(false);

const addProduct = (value) => {
  invoiceData.value?.purchasedProducts.push(value);
};

const removeProduct = (id) => {
  invoiceData.value?.purchasedProducts.splice(id, 1);
};
</script>

<template>
  <VRow>
    <!-- 👉 InvoiceEditable -->
    <VCol cols="12" md="9">
      <InvoiceEditable
        :data="invoiceData"
        @push="addProduct"
        @remove="removeProduct"
      />
    </VCol>

   
  </VRow>

  <!-- 👉 Send Invoice Sidebar -->
  <InvoiceSendInvoiceDrawer
    v-model:isDrawerOpen="isSendPaymentSidebarVisible"
  />
</template>
