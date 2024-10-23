<script setup>
import { ref } from 'vue';
import { useRoute } from 'vue-router';

const route = useRoute();
const paymentData = ref(null);
const isAddPaymentSidebarVisible = ref(false);
const loading = ref(true);
const error = ref(null);

try {
  const { data: paymentApiData } = await useApi(
    `/pagamentos/pagamento/${route.params.id}`
  );

  if (paymentApiData.value) {
    paymentData.value = paymentApiData.value;
    console.log("Dados do pagamento:", paymentData.value);
  } else {
    error.value = "Dados de pagamento não encontrados!";
  }
} catch (err) {
  error.value = "Erro ao buscar dados de pagamento: " + err.message;
} finally {
  loading.value = false;
}

const printInvoice = () => {
  window.print();
};
</script>

<template>
  <section v-if="loading">
    <VAlert type="info">Carregando dados do pagamento...</VAlert>
  </section>
  
  <section v-else-if="error">
    <VAlert type="error" variant="tonal">
      {{ error }}
    </VAlert>
  </section>

  <section v-else>
    <VRow>
      <VCol cols="12" md="9">
        <VCard class="invoice-preview-wrapper pa-sm-12 pa-6">
          <div
            class="invoice-header-preview d-flex flex-wrap justify-space-between align-sm-center flex-column flex-sm-row print-row bg-var-theme-background gap-6 rounded pa-6 mb-6"
          >
            <div>
              <h1 class="app-logo-title">{{ paymentData.referencia }}</h1>
              <h6 class="text-h6 font-weight-regular">
                Data: {{ paymentData.dataPagamento }}
              </h6>
            </div>
            <div>
              <h5 class="text-h5 mb-6">{{ paymentData.id }}</h5>
            </div>
          </div>

          <VRow class="print-row mb-3">
            <VCol class="text-no-wrap">
              <h6 class="text-h6 mb-4">Aluno</h6>
              <RouterLink
                :to="{
                  name: 'utilizadores-alunos-detalhes-id',
                  params: { id: paymentData.id_aluno },
                }"
              >
                <VBtn variant="outlined" color="info">{{
                  paymentData.aluno
                }}</VBtn>
              </RouterLink>
            </VCol>

            <VCol class="text-no-wrap">
              <h6 class="text-h6 mb-4">Responsável</h6>
              <RouterLink
                :to="{
                  name: 'utilizadores-funcionarios-detalhes-id',
                  params: { id: paymentData.id_responsavel },
                }"
              >
                <VBtn variant="outlined" color="info">{{
                  paymentData.responsavel
                }}</VBtn>
              </RouterLink>
            </VCol>
          </VRow>

          <VTable
            class="invoice-preview-table border text-high-emphasis overflow-hidden mb-6"
          >
            <thead>
              <tr>
                <th scope="col">Tipo de Pagamento</th>
                <th scope="col">Valor</th>
                <th scope="col">Método de Pagamento</th>
                <th scope="col">Estado</th>
              </tr>
            </thead>
            <tbody>
              <tr>
                <td>{{ paymentData.tipoPagamento }}</td>
                <td>{{ paymentData.valor.toFixed(2) }} MZN</td>
                <td>{{ paymentData.metodoPagamento }}</td>
                <td>{{ paymentData.estado }}</td>
              </tr>
            </tbody>
          </VTable>

          <VDivider class="my-6 border-dashed" />
          <p class="mb-0 text-body-1">
            <span class="text-high-emphasis font-weight-medium me-1"
              >Observação:</span
            >
            <span>{{ paymentData.observacao }}</span>
          </p>
        </VCard>
      </VCol>

      <VCol cols="12" md="3" class="d-print-none">
        <VCard>
          <VCardText>
            <VBtn
              block
              variant="outlined"
              color="secondary"
              class="mb-4 flex-grow-1"
              @click="printInvoice"
            >
              Imprimir Recibo
            </VBtn>

            <VBtn
              variant="outlined"
              block
              prepend-icon="ri-money-dollar-circle-line"
              class="mb-4 flex-grow-1"
              color="success"
              @click="isAddPaymentSidebarVisible = true"
            >
              Aprovar Pagamento
            </VBtn>
            <VBtn
              variant="outlined"
              block
              class="mb-4 flex-grow-1"
              prepend-icon="ri-money-dollar-circle-line"
              color="error"
              @click="isAddPaymentSidebarVisible = true"
            >
              Rejeitar Pagamento
            </VBtn>

            <VBtn block color="secondary" variant="outlined" class="mb-4">
              Baixar Recibo
            </VBtn>
          </VCardText>
        </VCard>
      </VCol>
    </VRow>
  </section>
</template>
