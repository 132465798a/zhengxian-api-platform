import{D as e,On as t,_ as n,b as r,et as i,g as a,k as o,mt as s,qt as c,tr as l,vn as u,xt as d,y as f}from"./runtime-core.esm-bundler-D1Q-n0wH.js";import{t as p}from"./locales-J2ce5-14.js";import{n as m,t as h}from"./objectSpread2-BzTFKcvP.js";import{n as g,t as _}from"./asyncToGenerator-C83J4upk.js";import{t as v}from"./_plugin-vue_export-helper-BDNMzG2s.js";import{t as y}from"./style-eusJYGtA.js";import{t as b}from"./basecomponent-C4Qtoha1.js";import{t as x}from"./inputtext-DOLd1JBp.js";import{a as S}from"./feedback-BsmiwBuT.js";import{m as C}from"./custom-page-CO6zALmU.js";import{t as w}from"./use-file-upload-MpLZUmqT.js";var T={name:`InputGroup`,extends:{name:`BaseInputGroup`,extends:b,style:y.extend({name:`inputgroup`,style:`
    .p-inputgroup,
    .p-inputgroup .p-iconfield,
    .p-inputgroup .p-floatlabel,
    .p-inputgroup .p-iftalabel {
        display: flex;
        align-items: stretch;
        width: 100%;
    }

    .p-inputgroup .p-floatlabel .p-inputwrapper,
    .p-inputgroup .p-iftalabel .p-inputwrapper {
        display: inline-flex;
    }

    .p-inputgroup .p-inputtext,
    .p-inputgroup .p-inputwrapper {
        flex: 1 1 auto;
        width: 1%;
    }

    .p-inputgroupaddon {
        display: flex;
        align-items: center;
        justify-content: center;
        padding: dt('inputgroup.addon.padding');
        background: dt('inputgroup.addon.background');
        color: dt('inputgroup.addon.color');
        border-block-start: 1px solid dt('inputgroup.addon.border.color');
        border-block-end: 1px solid dt('inputgroup.addon.border.color');
        min-width: dt('inputgroup.addon.min.width');
    }

    .p-inputgroupaddon:first-child,
    .p-inputgroupaddon + .p-inputgroupaddon {
        border-inline-start: 1px solid dt('inputgroup.addon.border.color');
    }

    .p-inputgroupaddon:last-child {
        border-inline-end: 1px solid dt('inputgroup.addon.border.color');
    }

    .p-inputgroupaddon:has(.p-button) {
        padding: 0;
        overflow: hidden;
    }

    .p-inputgroupaddon .p-button {
        border-radius: 0;
    }

    .p-inputgroup > .p-component,
    .p-inputgroup > .p-inputwrapper > .p-component,
    .p-inputgroup > .p-iconfield > .p-component,
    .p-inputgroup > .p-floatlabel > .p-component,
    .p-inputgroup > .p-floatlabel > .p-inputwrapper > .p-component,
    .p-inputgroup > .p-iftalabel > .p-component,
    .p-inputgroup > .p-iftalabel > .p-inputwrapper > .p-component {
        border-radius: 0;
        margin: 0;
    }

    .p-inputgroupaddon:first-child,
    .p-inputgroup > .p-component:first-child,
    .p-inputgroup > .p-inputwrapper:first-child > .p-component,
    .p-inputgroup > .p-iconfield:first-child > .p-component,
    .p-inputgroup > .p-floatlabel:first-child > .p-component,
    .p-inputgroup > .p-floatlabel:first-child > .p-inputwrapper > .p-component,
    .p-inputgroup > .p-iftalabel:first-child > .p-component,
    .p-inputgroup > .p-iftalabel:first-child > .p-inputwrapper > .p-component {
        border-start-start-radius: dt('inputgroup.addon.border.radius');
        border-end-start-radius: dt('inputgroup.addon.border.radius');
    }

    .p-inputgroupaddon:last-child,
    .p-inputgroup > .p-component:last-child,
    .p-inputgroup > .p-inputwrapper:last-child > .p-component,
    .p-inputgroup > .p-iconfield:last-child > .p-component,
    .p-inputgroup > .p-floatlabel:last-child > .p-component,
    .p-inputgroup > .p-floatlabel:last-child > .p-inputwrapper > .p-component,
    .p-inputgroup > .p-iftalabel:last-child > .p-component,
    .p-inputgroup > .p-iftalabel:last-child > .p-inputwrapper > .p-component {
        border-start-end-radius: dt('inputgroup.addon.border.radius');
        border-end-end-radius: dt('inputgroup.addon.border.radius');
    }

    .p-inputgroup .p-component:focus,
    .p-inputgroup .p-component.p-focus,
    .p-inputgroup .p-inputwrapper-focus,
    .p-inputgroup .p-component:focus ~ label,
    .p-inputgroup .p-component.p-focus ~ label,
    .p-inputgroup .p-inputwrapper-focus ~ label,
    .p-inputgroup .p-floatlabel .p-inputwrapper ~ label,
    .p-inputgroup .p-iftalabel .p-inputwrapper ~ label {
        z-index: 1;
    }

    .p-inputgroup > .p-button:not(.p-button-icon-only) {
        width: auto;
    }

    .p-inputgroup .p-iconfield + .p-iconfield .p-inputtext {
        border-inline-start: 0;
    }
`,classes:{root:`p-inputgroup`}}),provide:function(){return{$pcInputGroup:this,$parentInstance:this}}},inheritAttrs:!1};function E(e,t,n,a,o,c){return s(),r(`div`,i({class:e.cx(`root`)},e.ptmi(`root`)),[d(e.$slots,`default`)],16)}T.render=E;var D={name:`InputGroupAddon`,extends:{name:`BaseInputGroupAddon`,extends:b,style:y.extend({name:`inputgroupaddon`,classes:{root:`p-inputgroupaddon`}}),provide:function(){return{$pcInputGroupAddon:this,$parentInstance:this}}},inheritAttrs:!1};function O(e,t,n,a,o,c){return s(),r(`div`,i({class:e.cx(`root`)},e.ptmi(`root`)),[d(e.$slots,`default`)],16)}D.render=O,m(),g();var k={class:`custom-page-img-upload`},A={class:`custom-page-img-upload__action`},j=[`src`,`alt`],M=v(o(h(h({},{name:`CustomPageImgUploadField`}),{},{__name:`img-upload-field`,props:{config:{},model:{},name:{}},emits:[`change`],setup(i,{expose:o,emit:d}){let m=i,h=d,g=u(!1),v=a({get(){var e,t;return(e=(t=m.model)==null?void 0:t[m.name])==null?``:e},set(e){h(`change`,e)}}),{clearFiles:y,dropzoneRef:b,inputRef:E,openFileDialog:O}=w({accept:`image/*`,onFilesAdded:e=>{var t;let n=(t=e[0])==null?void 0:t.file;n instanceof File&&M(n)}});o({dropzoneRef:b,inputRef:E});function M(e){return N.apply(this,arguments)}function N(){return N=_(function*(e){g.value=!0;try{let t=yield C(e);v.value=t}catch(e){S.error(p(`content-ops-view.contentOps.customPageImgUploadField.uploadFailed`))}finally{g.value=!1,y()}}),N.apply(this,arguments)}return(a,o)=>{let u=x,d=D,m=T;return s(),r(`div`,k,[e(m,null,{default:c(()=>{var r;return[e(u,{modelValue:v.value,"onUpdate:modelValue":o[0]||(o[0]=e=>v.value=e),placeholder:((r=i.config)==null?void 0:r.placeholder)||t(p)(`content-ops-view.contentOps.customPageImgUploadField.placeholder`)},null,8,[`modelValue`,`placeholder`]),e(d,null,{default:c(()=>[n(`span`,{ref_key:`dropzoneRef`,ref:b,class:`inline-flex`,onClick:o[1]||(o[1]=(...e)=>t(O)&&t(O)(...e))},[n(`input`,{ref_key:`inputRef`,ref:E,"aria-label":`Upload image file`},null,512),n(`a`,A,l(g.value?t(p)(`content-ops-view.contentOps.customPageImgUploadField.uploading`):t(p)(`content-ops-view.contentOps.customPageImgUploadField.upload`)),1)],512)]),_:1})]}),_:1}),v.value?(s(),r(`img`,{key:0,src:v.value,alt:t(p)(`content-ops-view.contentOps.customPageImgUploadField.preview`),class:`custom-page-img-upload__preview`},null,8,j)):f(``,!0)])}}})),[[`__scopeId`,`data-v-29a48b30`]]);export{M as default};