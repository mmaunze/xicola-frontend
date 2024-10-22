<script setup>
import Sobre from "@/views/utilizadores/funcionarios/detalhes/Sobre.vue";

const route = useRoute("utilizadores-funcionarios-detalhes-id");
const funcionarioTab = ref(null);
const funcionarioData = ref(null);

const tabs = [
  {
    icon: "ri-book-3-line",
    title: "Disciplinas",
    content: "Informações ",
  },

  {
    icon: "ri-group-line",
    title: "Turmas",
    content: "Informações ",
  },

  {
    icon: "ri-book-line",
    title: "Aulas",
    content: "",
  },

  {
    icon: "ri-calendar-line",
    title: "Pautas",
    content: "",
  },
  {
    icon: "ri-award-line",
    title: "Actividades",
    content: "",
  },
  {
    icon: "ri-archive-2-line",
    title: "Documentos",
    content: "",
  },
];

const fetchFuncionario = async () => {
  try {
    const res = await $api(`/funcionarios/funcionario/${route.params.id}`, {
      method: "GET",
    });

    if (res) {
      funcionarioData.value = {
        id: res.id,
        nomeCompleto: res.nomeCompleto,
        dataNascimento: res.dataNascimento,
        distritoNascimento: res.distritoNascimento,
        provinciaNascimento: res.provinciaNascimento,
        nomeDoPai: res.nomeDoPai,
        nomeDaMae: res.nomeDaMae,
        religiao: res.religiao,
        cargo : res.cargo,
        departamento : res.departamento,
        grupoSanguineo: res.grupoSanguineo,
        endereco: res.endereco,
        dataContracto: res.dataContracto,
        escolaAnterior: res.escolaAnterior,
        estadoCivil: res.estadoCivil,
        areaFormacao: res.areaFormacao,
        bilheteIdentificacao: res.bilheteIdentificacao,
        numeroTelefonePrincipal: res.numeroTelefonePrincipal,
        numerroTelefoneAlternativo: res.numerroTelefoneAlternativo,
        sexo: res.sexo,
        estado: res.estado,
      };
    } else {
      console.error("Nenhum dado de funcionario encontrado.");
    }
  } catch (err) {
    console.error("Erro ao buscar funcionario:", err);
  }
};

onMounted(() => {
  fetchFuncionario();
});
</script>
<template>
  <VRow v-if="funcionarioData">
    <VCol cols="12" md="5" lg="4">
      <Sobre :funcionarioData="funcionarioData" />
    </VCol>

    <VCol cols="12" md="7" lg="8">
      <VTabs v-model="funcionarioTab" class="v-tabs-pill">
        <VTab v-for="tab in tabs" :key="tab.icon">
          <VIcon start :icon="tab.icon" />
          <span>{{ tab.title }}</span>
        </VTab>
      </VTabs>

      <VWindow
        v-model="funcionarioTab"
        class="mt-6 enable-tab-transition"
        :touch
      >
        <VWindowItem>
          <Aulas />
        </VWindowItem>

        <VWindowItem>
          <Pautas />
        </VWindowItem>

        <VWindowItem>
          <Disciplinas />
        </VWindowItem>

        <VWindowItem>
          <Turmas />
        </VWindowItem>

        <VWindowItem>
          <Actividades />
        </VWindowItem>

        <VWindowItem>
          <Documentacao />
        </VWindowItem>
      </VWindow>
    </VCol>
  </VRow>

  <div v-else>
    <VAlert type="error" variant="tonal">
      Funcionario {{ route.params.id }} não encontrado!
    </VAlert>
  </div>
</template>
