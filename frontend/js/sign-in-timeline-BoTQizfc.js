import{r as e}from"./rolldown-runtime-CNC7AqOf.js";import{D as t,On as n,Zn as r,_ as i,b as a,bt as o,et as s,k as c,mt as l,o as u,qt as d,tr as f,v as p,xt as m,y as h}from"./runtime-core.esm-bundler-D1Q-n0wH.js";import{t as g}from"./locales-J2ce5-14.js";import{t as _}from"./_plugin-vue_export-helper-BDNMzG2s.js";import{t as v}from"./style-eusJYGtA.js";import{O as y}from"./dist-cVYoUjJh.js";import{t as b}from"./classnames-CRHlWn3X.js";import{t as x}from"./basecomponent-C4Qtoha1.js";import{t as S}from"./tag-CJ1vu3qF.js";import{t as C}from"./skeleton-CHJNkI6N.js";var w=v.extend({name:`timeline`,style:`
    .p-timeline {
        display: flex;
        flex-grow: 1;
        flex-direction: column;
        direction: ltr;
        list-style: none;
        margin: 0;
        padding: 0;
    }

    .p-timeline-left .p-timeline-event-opposite {
        text-align: right;
    }

    .p-timeline-left .p-timeline-event-content {
        text-align: left;
    }

    .p-timeline-right .p-timeline-event {
        flex-direction: row-reverse;
    }

    .p-timeline-right .p-timeline-event-opposite {
        text-align: left;
    }

    .p-timeline-right .p-timeline-event-content {
        text-align: right;
    }

    .p-timeline-vertical.p-timeline-alternate .p-timeline-event:nth-child(even) {
        flex-direction: row-reverse;
    }

    .p-timeline-vertical.p-timeline-alternate .p-timeline-event:nth-child(odd) .p-timeline-event-opposite {
        text-align: right;
    }

    .p-timeline-vertical.p-timeline-alternate .p-timeline-event:nth-child(odd) .p-timeline-event-content {
        text-align: left;
    }

    .p-timeline-vertical.p-timeline-alternate .p-timeline-event:nth-child(even) .p-timeline-event-opposite {
        text-align: left;
    }

    .p-timeline-vertical.p-timeline-alternate .p-timeline-event:nth-child(even) .p-timeline-event-content {
        text-align: right;
    }

    .p-timeline-vertical .p-timeline-event-opposite,
    .p-timeline-vertical .p-timeline-event-content {
        padding: dt('timeline.vertical.event.content.padding');
    }

    .p-timeline-vertical .p-timeline-event-connector {
        width: dt('timeline.event.connector.size');
    }

    .p-timeline-event {
        display: flex;
        position: relative;
        min-height: dt('timeline.event.min.height');
    }

    .p-timeline-event:last-child {
        min-height: 0;
    }

    .p-timeline-event-opposite {
        flex: 1;
    }

    .p-timeline-event-content {
        flex: 1;
    }

    .p-timeline-event-separator {
        flex: 0;
        display: flex;
        align-items: center;
        flex-direction: column;
    }

    .p-timeline-event-marker {
        display: inline-flex;
        align-items: center;
        justify-content: center;
        position: relative;
        align-self: baseline;
        border-width: dt('timeline.event.marker.border.width');
        border-style: solid;
        border-color: dt('timeline.event.marker.border.color');
        border-radius: dt('timeline.event.marker.border.radius');
        width: dt('timeline.event.marker.size');
        height: dt('timeline.event.marker.size');
        background: dt('timeline.event.marker.background');
    }

    .p-timeline-event-marker::before {
        content: ' ';
        border-radius: dt('timeline.event.marker.content.border.radius');
        width: dt('timeline.event.marker.content.size');
        height: dt('timeline.event.marker.content.size');
        background: dt('timeline.event.marker.content.background');
    }

    .p-timeline-event-marker::after {
        content: ' ';
        position: absolute;
        width: 100%;
        height: 100%;
        border-radius: dt('timeline.event.marker.border.radius');
        box-shadow: dt('timeline.event.marker.content.inset.shadow');
    }

    .p-timeline-event-connector {
        flex-grow: 1;
        background: dt('timeline.event.connector.color');
    }

    .p-timeline-horizontal {
        flex-direction: row;
    }

    .p-timeline-horizontal .p-timeline-event {
        flex-direction: column;
        flex: 1;
    }

    .p-timeline-horizontal .p-timeline-event:last-child {
        flex: 0;
    }

    .p-timeline-horizontal .p-timeline-event-separator {
        flex-direction: row;
    }

    .p-timeline-horizontal .p-timeline-event-connector {
        width: 100%;
        height: dt('timeline.event.connector.size');
    }

    .p-timeline-horizontal .p-timeline-event-opposite,
    .p-timeline-horizontal .p-timeline-event-content {
        padding: dt('timeline.horizontal.event.content.padding');
    }

    .p-timeline-horizontal.p-timeline-alternate .p-timeline-event:nth-child(even) {
        flex-direction: column-reverse;
    }

    .p-timeline-bottom .p-timeline-event {
        flex-direction: column-reverse;
    }
`,classes:{root:function(e){var t=e.props;return[`p-timeline p-component`,`p-timeline-`+t.align,`p-timeline-`+t.layout]},event:`p-timeline-event`,eventOpposite:`p-timeline-event-opposite`,eventSeparator:`p-timeline-event-separator`,eventMarker:`p-timeline-event-marker`,eventConnector:`p-timeline-event-connector`,eventContent:`p-timeline-event-content`}}),T={name:`BaseTimeline`,extends:x,props:{value:null,align:{mode:String,default:`left`},layout:{mode:String,default:`vertical`},dataKey:null},style:w,provide:function(){return{$pcTimeline:this,$parentInstance:this}}};function E(e){"@babel/helpers - typeof";return E=typeof Symbol==`function`&&typeof Symbol.iterator==`symbol`?function(e){return typeof e}:function(e){return e&&typeof Symbol==`function`&&e.constructor===Symbol&&e!==Symbol.prototype?`symbol`:typeof e},E(e)}function D(e,t,n){return(t=O(t))in e?Object.defineProperty(e,t,{value:n,enumerable:!0,configurable:!0,writable:!0}):e[t]=n,e}function O(e){var t=k(e,`string`);return E(t)==`symbol`?t:t+``}function k(e,t){if(E(e)!=`object`||!e)return e;var n=e[Symbol.toPrimitive];if(n!==void 0){var r=n.call(e,t);if(E(r)!=`object`)return r;throw TypeError(`@@toPrimitive must return a primitive value.`)}return(t===`string`?String:Number)(e)}var A={name:`Timeline`,extends:T,inheritAttrs:!1,methods:{getKey:function(e,t){return this.dataKey?y(e,this.dataKey):t},getPTOptions:function(e,t){return this.ptm(e,{context:{index:t,count:this.value.length}})}},computed:{dataP:function(){return b(D(D({},this.layout,this.layout),this.align,this.align))}}},j=[`data-p`],M=[`data-p`],N=[`data-p`],P=[`data-p`],F=[`data-p`],I=[`data-p`],L=[`data-p`];function R(e,t,n,r,c,d){return l(),a(`ol`,s({class:e.cx(`root`)},e.ptmi(`root`),{"data-p":d.dataP}),[(l(!0),a(u,null,o(e.value,function(t,n){return l(),a(`li`,s({key:d.getKey(t,n),class:e.cx(`event`)},{ref_for:!0},d.getPTOptions(`event`,n),{"data-p":d.dataP}),[i(`div`,s({class:e.cx(`eventOpposite`,{index:n})},{ref_for:!0},d.getPTOptions(`eventOpposite`,n),{"data-p":d.dataP}),[m(e.$slots,`opposite`,{item:t,index:n})],16,N),i(`div`,s({class:e.cx(`eventSeparator`)},{ref_for:!0},d.getPTOptions(`eventSeparator`,n),{"data-p":d.dataP}),[m(e.$slots,`marker`,{item:t,index:n},function(){return[i(`div`,s({class:e.cx(`eventMarker`)},{ref_for:!0},d.getPTOptions(`eventMarker`,n),{"data-p":d.dataP}),null,16,F)]}),n===e.value.length-1?h(``,!0):m(e.$slots,`connector`,{key:0,item:t,index:n},function(){return[i(`div`,s({class:e.cx(`eventConnector`)},{ref_for:!0},d.getPTOptions(`eventConnector`,n),{"data-p":d.dataP}),null,16,I)]})],16,P),i(`div`,s({class:e.cx(`eventContent`)},{ref_for:!0},d.getPTOptions(`eventContent`,n),{"data-p":d.dataP}),[m(e.$slots,`content`,{item:t,index:n})],16,L)],16,M)}),128))],16,j)}A.render=R;var z={key:0,class:`space-y-2`},B={key:1,class:`text-muted-foreground flex flex-col items-center justify-center gap-2 py-8 text-center text-sm`},V={class:`tl-content`},H={class:`tl-title`},U={class:`tl-title-text`},W={class:`tl-detail`},G={class:`tl-date`},K=c({__name:`sign-in-timeline`,props:{timelineItems:{},timelineLoading:{type:Boolean}},setup(e){let s={LEVEL_UP:`bg-success border-success`,LEVEL_DOWN:`bg-destructive border-destructive`,BADGE:`bg-warning border-amber-500`,STREAK_MILESTONE:`bg-primary border-primary`,FREEZE:`bg-success border-cyan-600`,EXCHANGE:`bg-purple-600 border-purple-600`,AUTOMATION:`bg-indigo-600 border-indigo-600`},c={LEVEL_UP:`success`,LEVEL_DOWN:`danger`,BADGE:`warn`,STREAK_MILESTONE:`contrast`,FREEZE:`success`,EXCHANGE:`contrast`,AUTOMATION:`secondary`};return(m,h)=>{let _=C,v=S,y=A;return e.timelineLoading?(l(),a(`div`,z,[(l(),a(u,null,o(4,e=>t(_,{key:e,class:`h-10 w-full`})),64))])):e.timelineItems.length===0?(l(),a(`div`,B,[h[0]||(h[0]=i(`span`,{class:`i-mingcute-time-line text-lg`},null,-1)),i(`div`,null,f(n(g)(`redeem.signInModulesSignInTimeline.empty`)),1),i(`div`,null,f(n(g)(`redeem.signInModulesSignInTimeline.emptyDesc`)),1)])):(l(),p(y,{key:2,value:e.timelineItems,class:`tl-list`},{marker:d(({item:e})=>[i(`span`,{class:r([`tl-marker`,s[e.eventType]||`bg-primary border-primary`])},null,2)]),content:d(({item:e})=>[i(`div`,V,[i(`div`,H,[i(`span`,U,f(e.title),1),t(v,{severity:c[e.eventType]||`secondary`,value:e.eventType},null,8,[`severity`,`value`])]),i(`div`,W,f(e.detail),1),i(`div`,G,f(e.createTime),1)])]),_:1},8,[`value`]))}}}),q=e({default:()=>J}),J=_(K,[[`__scopeId`,`data-v-de5fa525`]]);export{q as n,J as t};