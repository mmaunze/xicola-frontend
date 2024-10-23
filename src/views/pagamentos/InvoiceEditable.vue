<script setup>
import { ref, computed, onMounted } from "vue";
import { VNodeRenderer } from "@layouts/components/VNodeRenderer";
import { themeConfig } from "@themeConfig";
import { useApi } from "@/composables/useApi"; // Composable para fazer chamadas à API

const props = defineProps({
  data: {
    type: Object,
    required: true,
  },
});

const emit = defineEmits(["update:payment"]);

// Estado inicial
const valor = ref(0);
const tipoPagamento = ref(null); // Tipo de pagamento selecionado
const metodoPagamento = ref(null); // Método de pagamento selecionado
const desconto = ref(0); // Percentual de desconto
const multa = ref(0); // Percentual de multa
const observacao = ref(""); // Campo de observação
const alunoSelecionado = ref(null); // Aluno selecionado (completo)
const alunos = ref([]); // Lista de alunos
const tiposPagamento = ref([]); // Tipos de pagamento a serem carregados do backend
const metodosPagamento = ref([]); // Métodos de pagamento a serem carregados do backend

// Função para buscar alunos
const fetchAlunos = async () => {
  const { data, error } = await useApi("/alunos");
  if (!error.value) {
    alunos.value = data.value;
  }
};

// Função para buscar tipos de pagamento
const fetchTiposPagamento = async () => {
  const { data, error } = await useApi("/tipos_pagamento");
  if (!error.value) {
    tiposPagamento.value = data.value.map((tipo) => tipo.nome); // Obter apenas os nomes
  }
};

// Função para buscar métodos de pagamento
const fetchMetodosPagamento = async () => {
  const { data, error } = await useApi("/metodos_pagamento");
  if (!error.value) {
    metodosPagamento.value = data.value.map((metodo) => metodo.nome); // Obter apenas os nomes
  }
};

// Carregar os dados ao montar o componente
onMounted(() => {
  fetchAlunos();
  fetchTiposPagamento();
  fetchMetodosPagamento();
});

// Cálculo do valor total (com desconto e multa)
const valorTotal = computed(() => {
  let valorComDesconto = valor.value - (valor.value * (desconto.value / 100));
  let valorComMulta = valorComDesconto + (valorComDesconto * (multa.value / 100));
  return valorComMulta.toFixed(2); // Retorna o valor com duas casas decimais
});

// Emitir evento ao salvar os dados do pagamento
const savePayment = () => {
  emit("update:payment", {
    valor: valor.value,
    tipoPagamento: tipoPagamento.value,
    metodoPagamento: metodoPagamento.value,
    aluno: alunoSelecionado.value, // Enviar aluno completo
    desconto: desconto.value,
    multa: multa.value,
    valorTotal: valorTotal.value, // Valor calculado
    observacao: observacao.value, // Observação adicionada
  });
};
</script>

<template>
  <VCard class="pa-sm-12 pa-6">
    <!-- Header -->
    <div
      class="d-flex flex-wrap justify-space-between flex-column rounded bg-var-theme-background flex-sm-row gap-6 pa-6 mb-6"
    >
      <div>
        <div class="app-logo mb-6">
          <VNodeRenderer :nodes="themeConfig.app.logo" />
          <h1 class="app-logo-title">{{ themeConfig.app.title }}</h1>
        </div>
        <h6 class="text-h6 mb-4">Detalhes do Pagamento:</h6>
      </div>
    </div>

    <!-- Detalhes do Aluno Selecionado -->
    <div v-if="alunoSelecionado" class="mt-6">
      <h6 class="text-h6 mb-4">Detalhes do Aluno</h6>
      <VRow>
        <VCol cols="12" md="6">
          <p>
            <strong>Nome Completo:</strong> {{ alunoSelecionado.nomeCompleto }}
          </p>
          <p>
            <strong>Data de Nascimento:</strong>
            {{ alunoSelecionado.dataNascimento }}
          </p>
          <p>
            <strong>Bilhete de Identificação:</strong>
            {{ alunoSelecionado.bilheteIdentificacao }}
          </p>
        </VCol>
        <VCol cols="12" md="6">
          <p><strong>Endereço:</strong> {{ alunoSelecionado.endereco }}</p>
          <p>
            <strong>Telefone Principal:</strong>
            {{ alunoSelecionado.numeroTelefonePrincipal }}
          </p>
          <p><strong>Email:</strong> {{ alunoSelecionado.email }}</p>
        </VCol>
      </VRow>
    </div>

    <!-- Formulário para o pagamento -->
    <VRow>
      <!-- Selecção do aluno -->
      <VCol cols="12" md="4">
        <h6 class="text-h6 mb-4">Aluno</h6>
        <VAutocomplete
          v-model="alunoSelecionado"
          :items="alunos"
          item-title="nomeCompleto"
          label="Selecione o Aluno"
          class="mb-4"
          return-object
        />
      </VCol>

      <!-- Tipo de Pagamento (carregado do backend) -->
      <VCol cols="12" md="4">
        <h6 class="text-h6 mb-4">Tipo de Pagamento</h6>
        <VSelect
          v-model="tipoPagamento"
          :items="tiposPagamento"
          label="Selecione o Tipo de Pagamento"
          class="mb-4"
        />
      </VCol>

      <!-- Método de Pagamento (carregado do backend) -->
      <VCol cols="12" md="4">
        <h6 class="text-h6 mb-4">Método de Pagamento</h6>
        <VSelect
          v-model="metodoPagamento"
          :items="metodosPagamento"
          label="Selecione o Método de Pagamento"
          class="mb-4"
        />
      </VCol>

      <!-- Valor do Pagamento -->
      <VCol cols="12" md="4">
        <h6 class="text-h6 mb-4">Valor</h6>
        <VTextField
          v-model="valor"
          type="number"
          label="Valor do Pagamento"
          prefix="MZN"
          class="mb-4"
        />
      </VCol>

      <!-- Desconto -->
      <VCol cols="12" md="4">
        <h6 class="text-h6 mb-4">Desconto (%)</h6>
        <VTextField
          v-model="desconto"
          type="number"
          label="Desconto em Percentual"
          suffix="%"
          class="mb-4"
        />
      </VCol>

      <!-- Multa -->
      <VCol cols="12" md="4">
        <h6 class="text-h6 mb-4">Multa (%)</h6>
        <VTextField
          v-model="multa"
          type="number"
          label="Multa em Percentual"
          suffix="%"
          class="mb-4"
        />
      </VCol>

      <!-- Valor Total Calculado -->
      <VCol cols="12" md="4">
        <h6 class="text-h6 mb-4">Valor Total</h6>
        <VTextField
          v-model="valorTotal"
          label="Valor Total"
          prefix="MZN"
          class="mb-4"
          :readonly="true"
        />
      </VCol>

      <!-- Observação -->
      <VCol cols="12" md="12">
        <h6 class="text-h6 mb-4">Observação:</h6>
        <VTextField
          v-model="observacao"
          label="Escreva uma observação (opcional)"
          class="mb-4"
          textarea
          rows="3"
        />
      </VCol>
    </VRow>

    <!-- Botão de Salvar -->
    <VBtn color="primary" @click="savePayment" class="mt-6">
      Salvar Pagamento
    </VBtn>
  </VCard>
</template>

<style scoped>
.app-logo {
  display: flex;
  align-items: center;
  column-gap: 0.5rem;

  .app-logo-title {
    font-size: 1.25rem;
    font-weight: 600;
    letter-spacing: 0.27px;
    line-height: 1.5rem;
    text-transform: capitalize;
  }
}
</style>
