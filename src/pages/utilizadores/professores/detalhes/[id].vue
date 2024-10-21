<script setup>
import Actividades from "@/views/utilizadores/professores/detalhes/Actividades.vue";
import Documentacao from "@/views/utilizadores/professores/detalhes/Documentacao.vue";
import Turmas from "@/views/utilizadores/professores/detalhes/Turmas.vue";
import Disciplinas from "@/views/utilizadores/professores/detalhes/Disciplinas.vue";
import Pautas from "@/views/utilizadores/professores/detalhes/Pautas.vue";
import Aulas from "@/views/utilizadores/professores/detalhes/Aulas.vue";
import Sobre from "@/views/utilizadores/professores/detalhes/Sobre.vue";

const route = useRoute("utilizadores-professores-detalhes-id"); 
const professorTab = ref(null);
const professorData = ref(null); 

const tabs = [
  {
    icon: "ri-book-3-line",
    title: "Disciplinas",
    content:
      "Informações ",
  },

  {
    icon: "ri-group-line",
    title: "Turmas",
    content:
      "Informações ",
  },

  {
    icon: "ri-book-line",
    title: "Aulas",
    content:
      "",
  },

  {
    icon: "ri-calendar-line",
    title: "Pautas",
    content: "",
  },
  {
    icon: "ri-award-line",
    title: "Actividades",
    content:
      "",
  },
  {
    icon: "ri-archive-2-line",
    title: "Documentos",
    content:
      "",
  }
];


const fetchProfessor = async () => {
  try {
    const res = await $api(`/professores/professor/${route.params.id}`, {
      method: "GET",
    });

    if (res) {
      professorData.value = {
        id: res.id,
        nomeCompleto: res.nomeCompleto,
        dataNascimento: res.dataNascimento,
        distritoNascimento: res.distritoNascimento,
        provinciaNascimento: res.provinciaNascimento,
        nomeDoPai: res.nomeDoPai,
        nomeDaMae: res.nomeDaMae,
        religiao: res.religiao,
        grupoSanguineo: res.grupoSanguineo,
        endereco: res.endereco,
        dataRegisto: res.dataContracto,
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
      console.error("Nenhum dado de professor encontrado.");
    }
  } catch (err) {
    console.error("Erro ao buscar professor:", err);
  }
};


onMounted(() => {
  fetchProfessor();
});
</script>
<template>
  <VRow v-if="professorData">
   
    <VCol cols="12" md="5" lg="4">
      <Sobre :user-data="professorData" />
    </VCol>

    
    <VCol cols="12" md="7" lg="8">
      <VTabs v-model="professorTab" class="v-tabs-pill">
        <VTab v-for="tab in tabs" :key="tab.icon">
          <VIcon start :icon="tab.icon" />
          <span>{{ tab.title }}</span>
        </VTab>
      </VTabs>

   
      <VWindow
        v-model="professorTab"
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
      Professor {{ route.params.id }} não encontrado!
    </VAlert>
  </div>
</template>
