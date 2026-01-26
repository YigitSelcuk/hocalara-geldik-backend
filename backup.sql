--
-- PostgreSQL database dump
--

\restrict HM3KtysWLijlhJvKMpnE18vjrPRPR6Sg71gnICHongDq9FIXxBAelxlMYGblxSF

-- Dumped from database version 15.15
-- Dumped by pg_dump version 15.15

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;

--
-- Name: ApprovalStatus; Type: TYPE; Schema: public; Owner: hocalara_admin
--

CREATE TYPE public."ApprovalStatus" AS ENUM (
    'PENDING',
    'APPROVED',
    'REJECTED'
);


ALTER TYPE public."ApprovalStatus" OWNER TO hocalara_admin;

--
-- Name: ChangeType; Type: TYPE; Schema: public; Owner: hocalara_admin
--

CREATE TYPE public."ChangeType" AS ENUM (
    'BRANCH_UPDATE',
    'TEACHER_CREATE',
    'TEACHER_UPDATE',
    'TEACHER_DELETE',
    'PACKAGE_CREATE',
    'PACKAGE_UPDATE',
    'PACKAGE_DELETE',
    'BLOG_CREATE',
    'BLOG_UPDATE',
    'BLOG_DELETE',
    'SUCCESS_CREATE',
    'SUCCESS_UPDATE',
    'SUCCESS_DELETE',
    'STUDENT_CREATE',
    'STUDENT_DELETE'
);


ALTER TYPE public."ChangeType" OWNER TO hocalara_admin;

--
-- Name: MediaType; Type: TYPE; Schema: public; Owner: hocalara_admin
--

CREATE TYPE public."MediaType" AS ENUM (
    'IMAGE',
    'VIDEO',
    'DOCUMENT'
);


ALTER TYPE public."MediaType" OWNER TO hocalara_admin;

--
-- Name: MenuPosition; Type: TYPE; Schema: public; Owner: hocalara_admin
--

CREATE TYPE public."MenuPosition" AS ENUM (
    'TOPBAR',
    'HEADER',
    'FOOTER'
);


ALTER TYPE public."MenuPosition" OWNER TO hocalara_admin;

--
-- Name: NotificationType; Type: TYPE; Schema: public; Owner: hocalara_admin
--

CREATE TYPE public."NotificationType" AS ENUM (
    'CHANGE_APPROVED',
    'CHANGE_REJECTED',
    'CHANGE_PENDING'
);


ALTER TYPE public."NotificationType" OWNER TO hocalara_admin;

--
-- Name: PageStatus; Type: TYPE; Schema: public; Owner: hocalara_admin
--

CREATE TYPE public."PageStatus" AS ENUM (
    'DRAFT',
    'PUBLISHED',
    'ARCHIVED'
);


ALTER TYPE public."PageStatus" OWNER TO hocalara_admin;

--
-- Name: PageType; Type: TYPE; Schema: public; Owner: hocalara_admin
--

CREATE TYPE public."PageType" AS ENUM (
    'REGULAR',
    'NEWS',
    'BLOG',
    'PHOTO_GALLERY',
    'VIDEO_GALLERY'
);


ALTER TYPE public."PageType" OWNER TO hocalara_admin;

--
-- Name: UserRole; Type: TYPE; Schema: public; Owner: hocalara_admin
--

CREATE TYPE public."UserRole" AS ENUM (
    'SUPER_ADMIN',
    'CENTER_ADMIN',
    'BRANCH_ADMIN',
    'EDITOR'
);


ALTER TYPE public."UserRole" OWNER TO hocalara_admin;

SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- Name: BannerCard; Type: TABLE; Schema: public; Owner: hocalara_admin
--

CREATE TABLE public."BannerCard" (
    id text NOT NULL,
    icon text NOT NULL,
    title text NOT NULL,
    description text NOT NULL,
    "bgColor" text NOT NULL,
    "hoverColor" text NOT NULL,
    link text NOT NULL,
    "order" integer DEFAULT 0 NOT NULL,
    "isActive" boolean DEFAULT true NOT NULL,
    "createdAt" timestamp(3) without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    "updatedAt" timestamp(3) without time zone NOT NULL,
    "buttonText" text
);


ALTER TABLE public."BannerCard" OWNER TO hocalara_admin;

--
-- Name: BlogPost; Type: TABLE; Schema: public; Owner: hocalara_admin
--

CREATE TABLE public."BlogPost" (
    id text NOT NULL,
    title text NOT NULL,
    excerpt text NOT NULL,
    content text NOT NULL,
    category text NOT NULL,
    author text NOT NULL,
    date text NOT NULL,
    image text NOT NULL,
    "readTime" text NOT NULL,
    "isActive" boolean DEFAULT true NOT NULL,
    "createdAt" timestamp(3) without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    "updatedAt" timestamp(3) without time zone NOT NULL,
    "branchId" text,
    "isFeatured" boolean DEFAULT false NOT NULL,
    "seoDescription" text,
    "seoKeywords" text,
    "seoTitle" text,
    slug text,
    "publishedAt" timestamp(3) without time zone
);


ALTER TABLE public."BlogPost" OWNER TO hocalara_admin;

--
-- Name: Branch; Type: TABLE; Schema: public; Owner: hocalara_admin
--

CREATE TABLE public."Branch" (
    id text NOT NULL,
    name text NOT NULL,
    slug text NOT NULL,
    description text,
    address text NOT NULL,
    phone text NOT NULL,
    whatsapp text,
    email text,
    lat double precision NOT NULL,
    lng double precision NOT NULL,
    image text,
    "customBanner" text,
    "successBanner" text,
    logo text,
    "primaryColor" text,
    "isActive" boolean DEFAULT true NOT NULL,
    "createdAt" timestamp(3) without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    "updatedAt" timestamp(3) without time zone NOT NULL,
    "weekdayHours" text DEFAULT '08:30 - 19:30'::text,
    "weekendHours" text DEFAULT '09:00 - 18:00'::text,
    features jsonb
);


ALTER TABLE public."Branch" OWNER TO hocalara_admin;

--
-- Name: Category; Type: TABLE; Schema: public; Owner: hocalara_admin
--

CREATE TABLE public."Category" (
    id text NOT NULL,
    name text NOT NULL,
    slug text NOT NULL,
    description text,
    image text,
    icon text,
    "parentId" text,
    "order" integer DEFAULT 0 NOT NULL,
    "isActive" boolean DEFAULT true NOT NULL,
    "seoTitle" text,
    "seoDescription" text,
    "createdAt" timestamp(3) without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    "updatedAt" timestamp(3) without time zone NOT NULL
);


ALTER TABLE public."Category" OWNER TO hocalara_admin;

--
-- Name: ChangeRequest; Type: TABLE; Schema: public; Owner: hocalara_admin
--

CREATE TABLE public."ChangeRequest" (
    id text NOT NULL,
    "changeType" public."ChangeType" NOT NULL,
    status public."ApprovalStatus" DEFAULT 'PENDING'::public."ApprovalStatus" NOT NULL,
    "requestedBy" text NOT NULL,
    "branchId" text NOT NULL,
    "entityId" text,
    "entityType" text,
    "oldData" jsonb,
    "newData" jsonb NOT NULL,
    "reviewedBy" text,
    "reviewedAt" timestamp(3) without time zone,
    "reviewNote" text,
    "createdAt" timestamp(3) without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    "updatedAt" timestamp(3) without time zone NOT NULL
);


ALTER TABLE public."ChangeRequest" OWNER TO hocalara_admin;

--
-- Name: ContactSubmission; Type: TABLE; Schema: public; Owner: hocalara_admin
--

CREATE TABLE public."ContactSubmission" (
    id text NOT NULL,
    name text NOT NULL,
    email text NOT NULL,
    phone text,
    subject text,
    message text NOT NULL,
    "branchId" text,
    "isRead" boolean DEFAULT false NOT NULL,
    "isReplied" boolean DEFAULT false NOT NULL,
    "createdAt" timestamp(3) without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    "updatedAt" timestamp(3) without time zone NOT NULL
);


ALTER TABLE public."ContactSubmission" OWNER TO hocalara_admin;

--
-- Name: EducationPackage; Type: TABLE; Schema: public; Owner: hocalara_admin
--

CREATE TABLE public."EducationPackage" (
    id text NOT NULL,
    name text NOT NULL,
    slug text NOT NULL,
    type text NOT NULL,
    description text NOT NULL,
    "shortDescription" text NOT NULL,
    price double precision,
    "originalPrice" double precision,
    image text,
    features jsonb,
    "videoCount" integer,
    "subjectCount" integer,
    duration text,
    "isPopular" boolean DEFAULT false NOT NULL,
    "isNew" boolean DEFAULT false NOT NULL,
    discount integer,
    "isActive" boolean DEFAULT true NOT NULL,
    "order" integer DEFAULT 0 NOT NULL,
    "createdAt" timestamp(3) without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    "updatedAt" timestamp(3) without time zone NOT NULL,
    "branchId" text
);


ALTER TABLE public."EducationPackage" OWNER TO hocalara_admin;

--
-- Name: ExamDate; Type: TABLE; Schema: public; Owner: hocalara_admin
--

CREATE TABLE public."ExamDate" (
    id text NOT NULL,
    "examName" text NOT NULL,
    "examDate" timestamp(3) without time zone NOT NULL,
    description text,
    "order" integer DEFAULT 0 NOT NULL,
    "isActive" boolean DEFAULT true NOT NULL,
    "createdAt" timestamp(3) without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    "updatedAt" timestamp(3) without time zone NOT NULL
);


ALTER TABLE public."ExamDate" OWNER TO hocalara_admin;

--
-- Name: Feature; Type: TABLE; Schema: public; Owner: hocalara_admin
--

CREATE TABLE public."Feature" (
    id text NOT NULL,
    title text NOT NULL,
    description text,
    icon text NOT NULL,
    section text NOT NULL,
    features jsonb,
    "order" integer DEFAULT 0 NOT NULL,
    "isActive" boolean DEFAULT true NOT NULL,
    "createdAt" timestamp(3) without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    "updatedAt" timestamp(3) without time zone NOT NULL
);


ALTER TABLE public."Feature" OWNER TO hocalara_admin;

--
-- Name: FranchiseApplication; Type: TABLE; Schema: public; Owner: hocalara_admin
--

CREATE TABLE public."FranchiseApplication" (
    id text NOT NULL,
    name text NOT NULL,
    surname text NOT NULL,
    phone text NOT NULL,
    email text NOT NULL,
    city text,
    message text,
    status text DEFAULT 'NEW'::text NOT NULL,
    notes text,
    "createdAt" timestamp(3) without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    "updatedAt" timestamp(3) without time zone NOT NULL
);


ALTER TABLE public."FranchiseApplication" OWNER TO hocalara_admin;

--
-- Name: HomeSection; Type: TABLE; Schema: public; Owner: hocalara_admin
--

CREATE TABLE public."HomeSection" (
    id text NOT NULL,
    title text,
    subtitle text,
    "order" integer DEFAULT 0 NOT NULL,
    "isActive" boolean DEFAULT true NOT NULL,
    "createdAt" timestamp(3) without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    "updatedAt" timestamp(3) without time zone NOT NULL,
    "buttonLink" text,
    "buttonText" text,
    content text,
    description text,
    page text NOT NULL,
    section text NOT NULL,
    "seoDescription" text,
    "seoKeywords" text,
    "seoTitle" text
);


ALTER TABLE public."HomeSection" OWNER TO hocalara_admin;

--
-- Name: Lead; Type: TABLE; Schema: public; Owner: hocalara_admin
--

CREATE TABLE public."Lead" (
    id text NOT NULL,
    name text NOT NULL,
    surname text NOT NULL,
    phone text NOT NULL,
    email text,
    "branchId" text,
    status text DEFAULT 'NEW'::text NOT NULL,
    notes text,
    "createdAt" timestamp(3) without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    "updatedAt" timestamp(3) without time zone NOT NULL
);


ALTER TABLE public."Lead" OWNER TO hocalara_admin;

--
-- Name: Media; Type: TABLE; Schema: public; Owner: hocalara_admin
--

CREATE TABLE public."Media" (
    id text NOT NULL,
    type public."MediaType" NOT NULL,
    filename text NOT NULL,
    "originalName" text NOT NULL,
    "mimeType" text NOT NULL,
    size integer NOT NULL,
    url text NOT NULL,
    thumbnail text,
    "pageId" text,
    alt text,
    caption text,
    "createdAt" timestamp(3) without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    "updatedAt" timestamp(3) without time zone NOT NULL
);


ALTER TABLE public."Media" OWNER TO hocalara_admin;

--
-- Name: Menu; Type: TABLE; Schema: public; Owner: hocalara_admin
--

CREATE TABLE public."Menu" (
    id text NOT NULL,
    name text NOT NULL,
    slug text NOT NULL,
    "position" public."MenuPosition" NOT NULL,
    "isActive" boolean DEFAULT true NOT NULL,
    "createdById" text NOT NULL,
    "createdAt" timestamp(3) without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    "updatedAt" timestamp(3) without time zone NOT NULL
);


ALTER TABLE public."Menu" OWNER TO hocalara_admin;

--
-- Name: MenuItem; Type: TABLE; Schema: public; Owner: hocalara_admin
--

CREATE TABLE public."MenuItem" (
    id text NOT NULL,
    "menuId" text NOT NULL,
    "parentId" text,
    label text NOT NULL,
    url text,
    "pageId" text,
    "categoryId" text,
    target text DEFAULT '_self'::text NOT NULL,
    "order" integer DEFAULT 0 NOT NULL,
    "isActive" boolean DEFAULT true NOT NULL,
    "seoTitle" text,
    "seoNoFollow" boolean DEFAULT false NOT NULL,
    "createdAt" timestamp(3) without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    "updatedAt" timestamp(3) without time zone NOT NULL
);


ALTER TABLE public."MenuItem" OWNER TO hocalara_admin;

--
-- Name: Notification; Type: TABLE; Schema: public; Owner: hocalara_admin
--

CREATE TABLE public."Notification" (
    id text NOT NULL,
    type public."NotificationType" NOT NULL,
    title text NOT NULL,
    message text NOT NULL,
    "userId" text NOT NULL,
    "changeRequestId" text,
    "isRead" boolean DEFAULT false NOT NULL,
    "createdAt" timestamp(3) without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    "updatedAt" timestamp(3) without time zone NOT NULL
);


ALTER TABLE public."Notification" OWNER TO hocalara_admin;

--
-- Name: Page; Type: TABLE; Schema: public; Owner: hocalara_admin
--

CREATE TABLE public."Page" (
    id text NOT NULL,
    type public."PageType" DEFAULT 'REGULAR'::public."PageType" NOT NULL,
    status public."PageStatus" DEFAULT 'DRAFT'::public."PageStatus" NOT NULL,
    title text NOT NULL,
    slug text NOT NULL,
    content text NOT NULL,
    excerpt text,
    "featuredImage" text,
    "categoryId" text,
    "authorId" text NOT NULL,
    "branchId" text,
    "isApproved" boolean DEFAULT false NOT NULL,
    "isFeatured" boolean DEFAULT false NOT NULL,
    "publishedAt" timestamp(3) without time zone,
    "seoTitle" text,
    "seoDescription" text,
    "seoKeywords" text,
    "createdAt" timestamp(3) without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    "updatedAt" timestamp(3) without time zone NOT NULL
);


ALTER TABLE public."Page" OWNER TO hocalara_admin;

--
-- Name: Setting; Type: TABLE; Schema: public; Owner: hocalara_admin
--

CREATE TABLE public."Setting" (
    id text NOT NULL,
    key text NOT NULL,
    value text NOT NULL,
    type text DEFAULT 'string'::text NOT NULL,
    "group" text DEFAULT 'general'::text NOT NULL,
    "createdAt" timestamp(3) without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    "updatedAt" timestamp(3) without time zone NOT NULL
);


ALTER TABLE public."Setting" OWNER TO hocalara_admin;

--
-- Name: Slider; Type: TABLE; Schema: public; Owner: hocalara_admin
--

CREATE TABLE public."Slider" (
    id text NOT NULL,
    title text NOT NULL,
    subtitle text,
    image text NOT NULL,
    link text,
    target text DEFAULT 'main'::text NOT NULL,
    "order" integer DEFAULT 0 NOT NULL,
    "isActive" boolean DEFAULT true NOT NULL,
    "createdById" text NOT NULL,
    "createdAt" timestamp(3) without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    "updatedAt" timestamp(3) without time zone NOT NULL,
    "primaryButtonLink" text,
    "primaryButtonText" text,
    "secondaryButtonLink" text,
    "secondaryButtonText" text
);


ALTER TABLE public."Slider" OWNER TO hocalara_admin;

--
-- Name: SocialMedia; Type: TABLE; Schema: public; Owner: hocalara_admin
--

CREATE TABLE public."SocialMedia" (
    id text NOT NULL,
    platform text NOT NULL,
    url text NOT NULL,
    "order" integer DEFAULT 0 NOT NULL,
    "isActive" boolean DEFAULT true NOT NULL,
    "createdAt" timestamp(3) without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    "updatedAt" timestamp(3) without time zone NOT NULL
);


ALTER TABLE public."SocialMedia" OWNER TO hocalara_admin;

--
-- Name: Statistic; Type: TABLE; Schema: public; Owner: hocalara_admin
--

CREATE TABLE public."Statistic" (
    id text NOT NULL,
    value text NOT NULL,
    label text NOT NULL,
    icon text NOT NULL,
    "order" integer DEFAULT 0 NOT NULL,
    "isActive" boolean DEFAULT true NOT NULL,
    "createdAt" timestamp(3) without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    "updatedAt" timestamp(3) without time zone NOT NULL
);


ALTER TABLE public."Statistic" OWNER TO hocalara_admin;

--
-- Name: SuccessBanner; Type: TABLE; Schema: public; Owner: hocalara_admin
--

CREATE TABLE public."SuccessBanner" (
    id text NOT NULL,
    "yearlySuccessId" text NOT NULL,
    title text NOT NULL,
    subtitle text NOT NULL,
    description text NOT NULL,
    image text NOT NULL,
    "highlightText" text,
    "gradientFrom" text DEFAULT '#2563eb'::text NOT NULL,
    "gradientTo" text DEFAULT '#1e40af'::text NOT NULL
);


ALTER TABLE public."SuccessBanner" OWNER TO hocalara_admin;

--
-- Name: Teacher; Type: TABLE; Schema: public; Owner: hocalara_admin
--

CREATE TABLE public."Teacher" (
    id text NOT NULL,
    name text NOT NULL,
    subject text NOT NULL,
    image text,
    "branchId" text,
    "isActive" boolean DEFAULT true NOT NULL,
    "order" integer DEFAULT 0 NOT NULL,
    "createdAt" timestamp(3) without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    "updatedAt" timestamp(3) without time zone NOT NULL
);


ALTER TABLE public."Teacher" OWNER TO hocalara_admin;

--
-- Name: TopStudent; Type: TABLE; Schema: public; Owner: hocalara_admin
--

CREATE TABLE public."TopStudent" (
    id text NOT NULL,
    "yearlySuccessId" text NOT NULL,
    name text NOT NULL,
    rank text NOT NULL,
    exam text NOT NULL,
    image text,
    branch text,
    university text,
    score double precision,
    "order" integer DEFAULT 0 NOT NULL
);


ALTER TABLE public."TopStudent" OWNER TO hocalara_admin;

--
-- Name: User; Type: TABLE; Schema: public; Owner: hocalara_admin
--

CREATE TABLE public."User" (
    id text NOT NULL,
    email text NOT NULL,
    password text NOT NULL,
    name text NOT NULL,
    role public."UserRole" DEFAULT 'EDITOR'::public."UserRole" NOT NULL,
    avatar text,
    "isActive" boolean DEFAULT true NOT NULL,
    "branchId" text,
    "createdAt" timestamp(3) without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    "updatedAt" timestamp(3) without time zone NOT NULL,
    "lastLoginAt" timestamp(3) without time zone
);


ALTER TABLE public."User" OWNER TO hocalara_admin;

--
-- Name: VideoLesson; Type: TABLE; Schema: public; Owner: hocalara_admin
--

CREATE TABLE public."VideoLesson" (
    id text NOT NULL,
    title text NOT NULL,
    description text NOT NULL,
    thumbnail text,
    "videoUrl" text NOT NULL,
    category text NOT NULL,
    subject text NOT NULL,
    duration text,
    views integer DEFAULT 0 NOT NULL,
    "uploadDate" timestamp(3) without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    teacher text,
    difficulty text,
    "isActive" boolean DEFAULT true NOT NULL,
    "order" integer DEFAULT 0 NOT NULL,
    "createdAt" timestamp(3) without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    "updatedAt" timestamp(3) without time zone NOT NULL
);


ALTER TABLE public."VideoLesson" OWNER TO hocalara_admin;

--
-- Name: YearlySuccess; Type: TABLE; Schema: public; Owner: hocalara_admin
--

CREATE TABLE public."YearlySuccess" (
    id text NOT NULL,
    year text NOT NULL,
    "totalDegrees" integer DEFAULT 0 NOT NULL,
    "placementCount" integer DEFAULT 0 NOT NULL,
    "successRate" double precision DEFAULT 0 NOT NULL,
    "cityCount" integer DEFAULT 0 NOT NULL,
    "top100Count" integer DEFAULT 0 NOT NULL,
    "top1000Count" integer DEFAULT 0 NOT NULL,
    "yksAverage" double precision DEFAULT 0 NOT NULL,
    "lgsAverage" double precision DEFAULT 0 NOT NULL,
    "isActive" boolean DEFAULT true NOT NULL,
    "createdAt" timestamp(3) without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    "updatedAt" timestamp(3) without time zone NOT NULL,
    "branchId" text
);


ALTER TABLE public."YearlySuccess" OWNER TO hocalara_admin;

--
-- Name: YouTubeChannel; Type: TABLE; Schema: public; Owner: hocalara_admin
--

CREATE TABLE public."YouTubeChannel" (
    id text NOT NULL,
    name text NOT NULL,
    url text NOT NULL,
    thumbnail text,
    subscribers text,
    "videoCount" text,
    description text,
    "order" integer DEFAULT 0 NOT NULL,
    "isActive" boolean DEFAULT true NOT NULL,
    "createdAt" timestamp(3) without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    "updatedAt" timestamp(3) without time zone NOT NULL
);


ALTER TABLE public."YouTubeChannel" OWNER TO hocalara_admin;

--
-- Name: _prisma_migrations; Type: TABLE; Schema: public; Owner: hocalara_admin
--

CREATE TABLE public._prisma_migrations (
    id character varying(36) NOT NULL,
    checksum character varying(64) NOT NULL,
    finished_at timestamp with time zone,
    migration_name character varying(255) NOT NULL,
    logs text,
    rolled_back_at timestamp with time zone,
    started_at timestamp with time zone DEFAULT now() NOT NULL,
    applied_steps_count integer DEFAULT 0 NOT NULL
);


ALTER TABLE public._prisma_migrations OWNER TO hocalara_admin;

--
-- Data for Name: BannerCard; Type: TABLE DATA; Schema: public; Owner: hocalara_admin
--

COPY public."BannerCard" (id, icon, title, description, "bgColor", "hoverColor", link, "order", "isActive", "createdAt", "updatedAt", "buttonText") FROM stdin;
3b774b5a-a891-40e8-90f2-419d0f805ba2	📄	Franchise Başvuru	Hocalara Geldik Ailesine Katılın	bg-[#3b82f6]	hover:bg-[#2563eb]	/franchise	1	t	2026-01-21 18:31:47.339	2026-01-21 18:31:47.339	DETAYLI BİLGİ
e6e00a36-a891-4dc7-901a-055b8fba6339	🏫	Başarı Merkezleri	81 İlde Güçlü Şube Ağı	bg-[#ec4899]	hover:bg-[#db2777]	/subeler	3	t	2026-01-21 18:31:47.358	2026-01-21 18:31:47.358	DETAYLI BİLGİ
404dfdb1-7410-4a25-81c1-1dcb8a7b1770	▶️	YouTubeasdas	Binlerce Ücretsiz İçerik	bg-red-600	hover:bg-red-700	/videolar	5	t	2026-01-21 18:31:47.362	2026-01-21 18:31:47.362	KANALA GİT
7bcdba22-1fe6-4730-a1cf-304463fd396c	🎓	Kayıt Başvurusu	Eğitiminize Hemen Başlayın	bg-red-600	hover:bg-red-700	/iletisim	2	t	2026-01-21 18:31:47.353	2026-01-21 18:31:47.353	DETAYLI BİLGİ
\.


--
-- Data for Name: BlogPost; Type: TABLE DATA; Schema: public; Owner: hocalara_admin
--

COPY public."BlogPost" (id, title, excerpt, content, category, author, date, image, "readTime", "isActive", "createdAt", "updatedAt", "branchId", "isFeatured", "seoDescription", "seoKeywords", "seoTitle", slug, "publishedAt") FROM stdin;
e5bbe943-ae49-4496-bba7-00e743d4edff	dfgdfgd	dfgdfg	dfgdg	Rehberlik	dfgd	2026-01-23	/uploads/1769198257087-924961232.jpg	5 dk	t	2026-01-23 19:57:37.525	2026-01-23 19:57:37.525	\N	f	\N	\N	\N	\N	\N
2476b016-53ed-473d-a736-17efe367284a	sadf	sdfs	sdfs	Genel		2026-01-24	/uploads/1769233197982-804208985.jpeg	5 dk	t	2026-01-24 05:31:51.119	2026-01-24 05:45:46.188	38aeca3e-8805-44e8-a87f-d87acabc0033	t	sdf	sdf	sdfssdf	sdfsds	\N
bc422bfe-d03e-4208-a035-dbd804a764eb	dsf	sdfdsdssf	sdfsfdsf	Genel		2026-01-24	/uploads/1769270940079-580302749.jpg	5 dk	t	2026-01-24 16:09:10.308	2026-01-24 16:09:10.308	38aeca3e-8805-44e8-a87f-d87acabc0033	t	dfdsfdsf	fsdfdsfs	ssdfs	sf	2026-01-24 16:09:10.307
7babfc61-4e85-4ea9-87f1-018e27287b23	sdfdssdfsfsfsfsf	fdsfs	fsfsfsdf	Genel		2026-01-26	/uploads/1769412988131-355344823.jpg	5 dk	t	2026-01-26 07:36:57.294	2026-01-26 07:38:26.096	38aeca3e-8805-44e8-a87f-d87acabc0033	t	sdfs	fdsfssdfsfs	sdfs	sfsfs	2026-01-26 07:36:57.293
c986ea62-6f31-4b62-b129-a946cb85cb86	dfssfsdfsfsfdsf	fdsfdsf	sdfdsfsdfsdfsd	Genel		2026-01-26	/uploads/1769413025065-473809428.jpg	5 dk	t	2026-01-26 07:38:30.118	2026-01-26 07:38:38.636	38aeca3e-8805-44e8-a87f-d87acabc0033	t	fdsfdsf	sdfdsfds	sdfs	sfdsfsfsfds	2026-01-26 07:38:30.117
\.


--
-- Data for Name: Branch; Type: TABLE DATA; Schema: public; Owner: hocalara_admin
--

COPY public."Branch" (id, name, slug, description, address, phone, whatsapp, email, lat, lng, image, "customBanner", "successBanner", logo, "primaryColor", "isActive", "createdAt", "updatedAt", "weekdayHours", "weekendHours", features) FROM stdin;
32904ae0-344e-447d-9e82-04add0acd926	İstanbul Kadıköy	istanbul-kadikoy	Kadıköy merkez şubemiz	Kadıköy, İstanbul	0216 XXX XX XX	0532 XXX XX XX	kadikoy@hocalarageldik.com	40.9903	29.0245	\N	\N	\N	\N	\N	t	2026-01-21 14:53:08.066	2026-01-21 14:53:08.066	08:30 - 19:30	09:00 - 18:00	\N
64a6057c-6f39-427f-9b66-40719fe43014	dfg	dfg	dfgd	dfg	dfg	dgdfgd	df	234	23423	\N	\N	\N	\N	\N	t	2026-01-22 13:16:28.885	2026-01-22 13:16:28.885	08:30 - 19:30	09:00 - 18:00	\N
7f9b6c3c-c704-4562-a2eb-0c30ae89dec6	BALÇOCA	balçoca	asdsad	Maraşel fevzi çakmak mahalessi 4098 sokak no 17	12312	3asdsa	12312@gmail.com	12.12312	23.543198	/uploads/1769149929889-752524400.jpg	\N	/uploads/1769149932493-482124623.jpeg	/uploads/1769149927446-799617088.jpg	#dff532	t	2026-01-23 06:32:35.746	2026-01-23 06:35:31.677	08:30 - 19:30	09:00 - 18:00	\N
38aeca3e-8805-44e8-a87f-d87acabc0033	UrlAdfds	urla	aasdsad	Maraşel fevzi çakmak mahalessi 4098 sokak no 17D	123123323	12312	asdasdads@gmail.com3	12.23423	34.345353	/uploads/1769186731473-757421767.jpg	\N	/uploads/1769186737785-796155916.jpg	/uploads/1769407738350-222638415.jpeg	#ceff1f	t	2026-01-23 06:36:47.391	2026-01-26 06:32:10.554	08:30 - 19:33	09:00 - 18:05	[{"icon": "Calendar", "text": "selamlar"}, {"icon": "Book", "text": "hocalara geldik"}]
\.


--
-- Data for Name: Category; Type: TABLE DATA; Schema: public; Owner: hocalara_admin
--

COPY public."Category" (id, name, slug, description, image, icon, "parentId", "order", "isActive", "seoTitle", "seoDescription", "createdAt", "updatedAt") FROM stdin;
d3c5a16f-9224-48d7-badf-83944e938d1f	Haberler	haberler	Kurumsal haberler ve duyurular	\N	\N	\N	1	t	\N	\N	2026-01-21 14:53:08.075	2026-01-21 14:53:08.075
\.


--
-- Data for Name: ChangeRequest; Type: TABLE DATA; Schema: public; Owner: hocalara_admin
--

COPY public."ChangeRequest" (id, "changeType", status, "requestedBy", "branchId", "entityId", "entityType", "oldData", "newData", "reviewedBy", "reviewedAt", "reviewNote", "createdAt", "updatedAt") FROM stdin;
1259883f-489b-443d-970b-a2784352b3c7	STUDENT_CREATE	APPROVED	aa5d5dba-0088-4074-950f-2f0336190f8b	38aeca3e-8805-44e8-a87f-d87acabc0033	b1a9d3be-91f0-40d2-86c2-d46b625244fd	TopStudent	\N	{"exam": "YKS", "name": "ASD", "rank": "12", "image": "/uploads/1769415387518-622629522.jpg", "order": 0, "score": 123, "branch": "BİLGİ", "university": "BOGAZ", "yearlySuccessId": "b1a9d3be-91f0-40d2-86c2-d46b625244fd"}	dde31d5c-b9ef-4f4f-b4f9-95192ec3ea8a	2026-01-26 08:16:32.917		2026-01-26 08:16:27.645	2026-01-26 08:16:32.918
9ed08bc0-745d-4a5a-a85a-85e15edc5b42	BRANCH_UPDATE	REJECTED	aa5d5dba-0088-4074-950f-2f0336190f8b	38aeca3e-8805-44e8-a87f-d87acabc0033	38aeca3e-8805-44e8-a87f-d87acabc0033	Branch	{"id": "38aeca3e-8805-44e8-a87f-d87acabc0033", "lat": 12.23423, "lng": 34.345353, "logo": "/uploads/1769150187452-948028599.jpg", "name": "Urla", "slug": "urla", "email": "asdasdads@gmail.com", "image": "/uploads/1769150189945-789821895.jpg", "phone": "123123", "address": "Maraşel fevzi çakmak mahalessi 4098 sokak no 17", "isActive": true, "whatsapp": "12312", "createdAt": "2026-01-23T06:36:47.391Z", "updatedAt": "2026-01-23T06:36:47.391Z", "description": "aasdsad", "customBanner": null, "primaryColor": "#ceff1f", "successBanner": "/uploads/1769150192409-430924694.jpeg"}	{"id": "38aeca3e-8805-44e8-a87f-d87acabc0033", "lat": 12.23423, "lng": 34.345353, "logo": "/uploads/1769150187452-948028599.jpg", "name": "Urlafghff", "slug": "urla", "email": "asdasdads@gmail.com", "image": "/uploads/1769150189945-789821895.jpg", "phone": "123123", "users": [{"id": "aa5d5dba-0088-4074-950f-2f0336190f8b", "name": "ahmet", "role": "BRANCH_ADMIN", "email": "sube@urla.com"}], "_count": {"pages": 0}, "address": "Maraşel fevzi çakmak mahalessi 4098 sokak no 17", "isActive": true, "whatsapp": "12312", "createdAt": "2026-01-23T06:36:47.391Z", "updatedAt": "2026-01-23T06:36:47.391Z", "description": "aasdsad", "customBanner": null, "primaryColor": "#ceff1f", "successBanner": "/uploads/1769150192409-430924694.jpeg"}	dde31d5c-b9ef-4f4f-b4f9-95192ec3ea8a	2026-01-23 08:33:20.46	olmaz la gardaş	2026-01-23 08:31:39.423	2026-01-23 08:33:20.461
eb608ee0-d172-4582-b1f2-f6c0d6313cba	BRANCH_UPDATE	APPROVED	aa5d5dba-0088-4074-950f-2f0336190f8b	38aeca3e-8805-44e8-a87f-d87acabc0033	38aeca3e-8805-44e8-a87f-d87acabc0033	Branch	{"id": "38aeca3e-8805-44e8-a87f-d87acabc0033", "lat": 12.23423, "lng": 34.345353, "logo": "/uploads/1769150187452-948028599.jpg", "name": "Urla", "slug": "urla", "email": "asdasdads@gmail.com", "image": "/uploads/1769150189945-789821895.jpg", "phone": "123123", "address": "Maraşel fevzi çakmak mahalessi 4098 sokak no 17", "isActive": true, "whatsapp": "12312", "createdAt": "2026-01-23T06:36:47.391Z", "updatedAt": "2026-01-23T06:36:47.391Z", "description": "aasdsad", "customBanner": null, "primaryColor": "#ceff1f", "successBanner": "/uploads/1769150192409-430924694.jpeg"}	{"id": "38aeca3e-8805-44e8-a87f-d87acabc0033", "lat": 12.23423, "lng": 34.345353, "logo": "/uploads/1769150187452-948028599.jpg", "name": "asdUrla", "slug": "urla", "email": "asdasdads@gmail.com", "image": "/uploads/1769150189945-789821895.jpg", "phone": "123123", "users": [{"id": "aa5d5dba-0088-4074-950f-2f0336190f8b", "name": "ahmet", "role": "BRANCH_ADMIN", "email": "sube@urla.com"}], "_count": {"pages": 0}, "address": "Maraşel fevzi çakmak mahalessi 4098 sokak no 17", "isActive": true, "whatsapp": "12312", "createdAt": "2026-01-23T06:36:47.391Z", "updatedAt": "2026-01-23T06:36:47.391Z", "description": "aasdsad", "customBanner": null, "primaryColor": "#ceff1f", "successBanner": "/uploads/1769150192409-430924694.jpeg"}	dde31d5c-b9ef-4f4f-b4f9-95192ec3ea8a	2026-01-23 09:02:31.604	Test approval from script	2026-01-23 08:31:34.318	2026-01-23 09:02:31.605
e72edd3a-0a44-4966-b7ca-acbf65825937	BRANCH_UPDATE	REJECTED	aa5d5dba-0088-4074-950f-2f0336190f8b	38aeca3e-8805-44e8-a87f-d87acabc0033	38aeca3e-8805-44e8-a87f-d87acabc0033	Branch	{"id": "38aeca3e-8805-44e8-a87f-d87acabc0033", "lat": 12.23423, "lng": 34.345353, "logo": "/uploads/1769150187452-948028599.jpg", "name": "Urla", "slug": "urla", "email": "asdasdads@gmail.com", "image": "/uploads/1769150189945-789821895.jpg", "phone": "123123", "address": "Maraşel fevzi çakmak mahalessi 4098 sokak no 17", "isActive": true, "whatsapp": "12312", "createdAt": "2026-01-23T06:36:47.391Z", "updatedAt": "2026-01-23T06:36:47.391Z", "description": "aasdsad", "customBanner": null, "primaryColor": "#ceff1f", "successBanner": "/uploads/1769150192409-430924694.jpeg"}	{"id": "38aeca3e-8805-44e8-a87f-d87acabc0033", "lat": 12.23423, "lng": 34.345353, "logo": "/uploads/1769150187452-948028599.jpg", "name": "Urlam", "slug": "urla", "email": "asdasdads@gmail.com", "image": "/uploads/1769150189945-789821895.jpg", "phone": "123123", "users": [{"id": "aa5d5dba-0088-4074-950f-2f0336190f8b", "name": "ahmet", "role": "BRANCH_ADMIN", "email": "sube@urla.com"}], "_count": {"pages": 0}, "address": "Maraşel fevzi çakmak mahalessi 4098 sokak no 17", "isActive": true, "whatsapp": "12312", "createdAt": "2026-01-23T06:36:47.391Z", "updatedAt": "2026-01-23T06:36:47.391Z", "description": "aasdsad", "customBanner": null, "primaryColor": "#ceff1f", "successBanner": "/uploads/1769150192409-430924694.jpeg"}	dde31d5c-b9ef-4f4f-b4f9-95192ec3ea8a	2026-01-23 16:36:56.463		2026-01-23 09:00:41.636	2026-01-23 16:36:56.464
3470031d-6244-4268-a0fe-461c25eaa98e	BRANCH_UPDATE	REJECTED	aa5d5dba-0088-4074-950f-2f0336190f8b	38aeca3e-8805-44e8-a87f-d87acabc0033	38aeca3e-8805-44e8-a87f-d87acabc0033	Branch	{"id": "38aeca3e-8805-44e8-a87f-d87acabc0033", "lat": 12.23423, "lng": 34.345353, "logo": "/uploads/1769186726290-921299469.jpg", "name": "Urlamf", "slug": "urla", "email": "asdasdads@gmail.com", "image": "/uploads/1769186731473-757421767.jpg", "phone": "123123", "address": "Maraşel fevzi çakmak mahalessi 4098 sokak no 17", "isActive": true, "whatsapp": "12312", "createdAt": "2026-01-23T06:36:47.391Z", "updatedAt": "2026-01-23T16:45:48.894Z", "description": "aasdsad", "customBanner": null, "primaryColor": "#ceff1f", "successBanner": "/uploads/1769186737785-796155916.jpg"}	{"lat": 12.23423, "lng": 34.345353, "logo": "/uploads/1769186726290-921299469.jpg", "name": "dfggdUrlamf", "slug": "urla", "email": "asdasdads@gmail.com", "image": "/uploads/1769186731473-757421767.jpg", "phone": "123123", "address": "Maraşel fevzi çakmak mahalessi 4098 sokak no 17", "isActive": true, "whatsapp": "12312", "description": "aasdsad", "customBanner": null, "primaryColor": "#ceff1f", "successBanner": "/uploads/1769186737785-796155916.jpg"}	dde31d5c-b9ef-4f4f-b4f9-95192ec3ea8a	2026-01-23 17:19:07.21		2026-01-23 17:11:59.283	2026-01-23 17:19:07.211
133d5dfd-84dd-4e88-b6c1-15640861d814	BRANCH_UPDATE	APPROVED	aa5d5dba-0088-4074-950f-2f0336190f8b	38aeca3e-8805-44e8-a87f-d87acabc0033	38aeca3e-8805-44e8-a87f-d87acabc0033	Branch	{"id": "38aeca3e-8805-44e8-a87f-d87acabc0033", "lat": 12.23423, "lng": 34.345353, "logo": "/uploads/1769150187452-948028599.jpg", "name": "Urla", "slug": "urla", "email": "asdasdads@gmail.com", "image": "/uploads/1769150189945-789821895.jpg", "phone": "123123", "address": "Maraşel fevzi çakmak mahalessi 4098 sokak no 17", "isActive": true, "whatsapp": "12312", "createdAt": "2026-01-23T06:36:47.391Z", "updatedAt": "2026-01-23T06:36:47.391Z", "description": "aasdsad", "customBanner": null, "primaryColor": "#ceff1f", "successBanner": "/uploads/1769150192409-430924694.jpeg"}	{"id": "38aeca3e-8805-44e8-a87f-d87acabc0033", "lat": 12.23423, "lng": 34.345353, "logo": "/uploads/1769150187452-948028599.jpg", "name": "Urlamf", "slug": "urla", "email": "asdasdads@gmail.com", "image": "/uploads/1769150189945-789821895.jpg", "phone": "123123", "users": [{"id": "aa5d5dba-0088-4074-950f-2f0336190f8b", "name": "ahmet", "role": "BRANCH_ADMIN", "email": "sube@urla.com"}], "_count": {"pages": 0}, "address": "Maraşel fevzi çakmak mahalessi 4098 sokak no 17", "isActive": true, "whatsapp": "12312", "createdAt": "2026-01-23T06:36:47.391Z", "updatedAt": "2026-01-23T06:36:47.391Z", "description": "aasdsad", "customBanner": null, "primaryColor": "#ceff1f", "successBanner": "/uploads/1769150192409-430924694.jpeg"}	dde31d5c-b9ef-4f4f-b4f9-95192ec3ea8a	2026-01-23 16:38:44.608		2026-01-23 16:37:06.848	2026-01-23 16:38:44.609
7141bbc7-d445-498f-b1a3-b1be78f79523	TEACHER_CREATE	APPROVED	aa5d5dba-0088-4074-950f-2f0336190f8b	38aeca3e-8805-44e8-a87f-d87acabc0033	\N	Teacher	\N	{"name": "dfgfd", "image": "", "subject": "dfgdfgd", "branchId": "38aeca3e-8805-44e8-a87f-d87acabc0033"}	dde31d5c-b9ef-4f4f-b4f9-95192ec3ea8a	2026-01-23 16:39:22.846		2026-01-23 16:39:11.718	2026-01-23 16:39:22.847
d685e053-105c-4df3-8b33-8e2218bcc4b6	TEACHER_CREATE	APPROVED	aa5d5dba-0088-4074-950f-2f0336190f8b	38aeca3e-8805-44e8-a87f-d87acabc0033	\N	Teacher	\N	{"name": "dfgfdg", "image": "", "subject": "dfgdfg", "branchId": "38aeca3e-8805-44e8-a87f-d87acabc0033"}	dde31d5c-b9ef-4f4f-b4f9-95192ec3ea8a	2026-01-23 16:41:47.741		2026-01-23 16:39:39.596	2026-01-23 16:41:47.742
6b1b56be-c414-4ad3-aabd-9d761ad57945	BRANCH_UPDATE	APPROVED	aa5d5dba-0088-4074-950f-2f0336190f8b	38aeca3e-8805-44e8-a87f-d87acabc0033	38aeca3e-8805-44e8-a87f-d87acabc0033	Branch	{"id": "38aeca3e-8805-44e8-a87f-d87acabc0033", "lat": 12.23423, "lng": 34.345353, "logo": "/uploads/1769150187452-948028599.jpg", "name": "Urlamf", "slug": "urla", "email": "asdasdads@gmail.com", "image": "/uploads/1769150189945-789821895.jpg", "phone": "123123", "address": "Maraşel fevzi çakmak mahalessi 4098 sokak no 17", "isActive": true, "whatsapp": "12312", "createdAt": "2026-01-23T06:36:47.391Z", "updatedAt": "2026-01-23T16:38:44.605Z", "description": "aasdsad", "customBanner": null, "primaryColor": "#ceff1f", "successBanner": "/uploads/1769150192409-430924694.jpeg"}	{"lat": 12.23423, "lng": 34.345353, "logo": "/uploads/1769186726290-921299469.jpg", "name": "Urlamf", "slug": "urla", "email": "asdasdads@gmail.com", "image": "/uploads/1769186731473-757421767.jpg", "phone": "123123", "address": "Maraşel fevzi çakmak mahalessi 4098 sokak no 17", "isActive": true, "whatsapp": "12312", "description": "aasdsad", "customBanner": null, "primaryColor": "#ceff1f", "successBanner": "/uploads/1769186737785-796155916.jpg"}	dde31d5c-b9ef-4f4f-b4f9-95192ec3ea8a	2026-01-23 16:45:48.899		2026-01-23 16:45:38.307	2026-01-23 16:45:48.9
c65afe94-5051-4d38-b838-3005810f00ed	TEACHER_DELETE	APPROVED	aa5d5dba-0088-4074-950f-2f0336190f8b	38aeca3e-8805-44e8-a87f-d87acabc0033	ce2485a0-1905-4129-be4c-ed0ad3589285	Teacher	{"id": "ce2485a0-1905-4129-be4c-ed0ad3589285", "name": "dfgfdg", "image": "", "order": 0, "subject": "dfgdfg", "branchId": "38aeca3e-8805-44e8-a87f-d87acabc0033", "isActive": true, "createdAt": "2026-01-23T16:41:47.739Z", "updatedAt": "2026-01-23T16:41:47.739Z"}	{"deleted": true}	dde31d5c-b9ef-4f4f-b4f9-95192ec3ea8a	2026-01-23 16:45:54.072		2026-01-23 16:45:11.554	2026-01-23 16:45:54.073
966573ac-c4dc-4b19-8ef0-45bcfd98c6ce	TEACHER_DELETE	APPROVED	aa5d5dba-0088-4074-950f-2f0336190f8b	38aeca3e-8805-44e8-a87f-d87acabc0033	3ad368b6-b0ad-4c3f-9036-9a69f962c5c5	Teacher	{"id": "3ad368b6-b0ad-4c3f-9036-9a69f962c5c5", "name": "dfgfd", "image": "", "order": 0, "subject": "dfgdfgd", "branchId": "38aeca3e-8805-44e8-a87f-d87acabc0033", "isActive": true, "createdAt": "2026-01-23T16:39:22.839Z", "updatedAt": "2026-01-23T16:39:22.839Z"}	{"deleted": true}	dde31d5c-b9ef-4f4f-b4f9-95192ec3ea8a	2026-01-23 16:45:59.269		2026-01-23 16:45:09.179	2026-01-23 16:45:59.269
90bd9f18-5fd2-40ca-ad55-6a889451e5a1	TEACHER_DELETE	REJECTED	aa5d5dba-0088-4074-950f-2f0336190f8b	38aeca3e-8805-44e8-a87f-d87acabc0033	3ad368b6-b0ad-4c3f-9036-9a69f962c5c5	Teacher	{"id": "3ad368b6-b0ad-4c3f-9036-9a69f962c5c5", "name": "dfgfd", "image": "", "order": 0, "subject": "dfgdfgd", "branchId": "38aeca3e-8805-44e8-a87f-d87acabc0033", "isActive": true, "createdAt": "2026-01-23T16:39:22.839Z", "updatedAt": "2026-01-23T16:39:22.839Z"}	{"deleted": true}	dde31d5c-b9ef-4f4f-b4f9-95192ec3ea8a	2026-01-23 16:46:08.872		2026-01-23 16:45:07.908	2026-01-23 16:46:08.873
4d04f8c2-477c-4731-b43d-0e7d30fe7e36	TEACHER_CREATE	APPROVED	aa5d5dba-0088-4074-950f-2f0336190f8b	38aeca3e-8805-44e8-a87f-d87acabc0033	\N	Teacher	\N	{"name": "dfg", "image": "", "subject": "ddfgdfg", "branchId": "38aeca3e-8805-44e8-a87f-d87acabc0033"}	dde31d5c-b9ef-4f4f-b4f9-95192ec3ea8a	2026-01-23 16:56:19.578		2026-01-23 16:55:15.195	2026-01-23 16:56:19.582
94518a80-77fe-4c3f-a424-0981a5dd0a43	TEACHER_DELETE	APPROVED	aa5d5dba-0088-4074-950f-2f0336190f8b	38aeca3e-8805-44e8-a87f-d87acabc0033	6fb8516b-e1e4-4942-9e3c-16424f021385	Teacher	{"id": "6fb8516b-e1e4-4942-9e3c-16424f021385", "name": "dfg", "image": "", "order": 0, "subject": "ddfgdfg", "branchId": "38aeca3e-8805-44e8-a87f-d87acabc0033", "isActive": true, "createdAt": "2026-01-23T16:56:19.569Z", "updatedAt": "2026-01-23T16:56:19.569Z"}	{"deleted": true}	dde31d5c-b9ef-4f4f-b4f9-95192ec3ea8a	2026-01-23 16:56:46.51	fghfh	2026-01-23 16:56:28.887	2026-01-23 16:56:46.511
93ae9811-f90a-47b0-a73c-184f2a08806d	TEACHER_CREATE	APPROVED	aa5d5dba-0088-4074-950f-2f0336190f8b	38aeca3e-8805-44e8-a87f-d87acabc0033	\N	Teacher	\N	{"name": "dfgdg", "image": "", "subject": "dfgdgdg", "branchId": "38aeca3e-8805-44e8-a87f-d87acabc0033"}	dde31d5c-b9ef-4f4f-b4f9-95192ec3ea8a	2026-01-23 17:19:11.871		2026-01-23 17:11:43.033	2026-01-23 17:19:11.872
2837daf8-047c-4cb1-bbea-8e835e4ce017	BLOG_CREATE	APPROVED	aa5d5dba-0088-4074-950f-2f0336190f8b	38aeca3e-8805-44e8-a87f-d87acabc0033	\N	BlogPost	\N	{"date": "2026-01-24", "slug": "dadsad", "image": "/uploads/1769253793623-678396837.jpg", "title": "asd", "author": "", "content": "adadasada", "excerpt": "adad", "branchId": "38aeca3e-8805-44e8-a87f-d87acabc0033", "category": "Genel", "isActive": true, "readTime": "5 dk", "seoTitle": "asda", "isFeatured": false, "seoKeywords": "das", "seoDescription": "dasda"}	dde31d5c-b9ef-4f4f-b4f9-95192ec3ea8a	2026-01-24 11:23:23.875		2026-01-24 11:23:16.865	2026-01-24 11:23:23.876
b1654a6f-eec7-46b2-8e43-7da18f19698a	SUCCESS_CREATE	APPROVED	aa5d5dba-0088-4074-950f-2f0336190f8b	38aeca3e-8805-44e8-a87f-d87acabc0033	\N	YearlySuccess	\N	{"year": 2026, "banner": {"image": "/uploads/1769254937364-448045755.jpg", "title": "sfdsf", "subtitle": "fdsfs"}, "branchId": "38aeca3e-8805-44e8-a87f-d87acabc0033", "cityCount": 0, "lgsAverage": 0, "yksAverage": 0, "successRate": 0, "top100Count": 0, "top1000Count": 0, "totalDegrees": 0, "placementCount": 0}	dde31d5c-b9ef-4f4f-b4f9-95192ec3ea8a	2026-01-24 11:47:39.917		2026-01-24 11:43:04.394	2026-01-24 11:47:39.919
5c096a30-a5ed-4b53-8aff-f4ff7b75856d	BRANCH_UPDATE	APPROVED	aa5d5dba-0088-4074-950f-2f0336190f8b	38aeca3e-8805-44e8-a87f-d87acabc0033	38aeca3e-8805-44e8-a87f-d87acabc0033	Branch	{"id": "38aeca3e-8805-44e8-a87f-d87acabc0033", "lat": 12.23423, "lng": 34.345353, "logo": "/uploads/1769186726290-921299469.jpg", "name": "Urlamf", "slug": "urla", "email": "asdasdads@gmail.com", "image": "/uploads/1769186731473-757421767.jpg", "phone": "123123", "address": "Maraşel fevzi çakmak mahalessi 4098 sokak no 17", "isActive": true, "whatsapp": "12312", "createdAt": "2026-01-23T06:36:47.391Z", "updatedAt": "2026-01-23T16:45:48.894Z", "description": "aasdsad", "customBanner": null, "primaryColor": "#ceff1f", "successBanner": "/uploads/1769186737785-796155916.jpg"}	{"lat": 12.23423, "lng": 34.345353, "logo": "/uploads/1769186726290-921299469.jpg", "name": "Urlamfdfgdg", "slug": "urla", "email": "asdasdads@gmail.com", "image": "/uploads/1769186731473-757421767.jpg", "phone": "123123", "address": "Maraşel fevzi çakmak mahalessi 4098 sokak no 17", "isActive": true, "whatsapp": "12312", "description": "aasdsad", "customBanner": null, "primaryColor": "#ceff1f", "successBanner": "/uploads/1769186737785-796155916.jpg"}	dde31d5c-b9ef-4f4f-b4f9-95192ec3ea8a	2026-01-23 17:19:03.814		2026-01-23 17:12:01.834	2026-01-23 17:19:03.815
931488ce-685e-4bee-9344-b48ae907b73b	BRANCH_UPDATE	APPROVED	aa5d5dba-0088-4074-950f-2f0336190f8b	38aeca3e-8805-44e8-a87f-d87acabc0033	38aeca3e-8805-44e8-a87f-d87acabc0033	Branch	{"id": "38aeca3e-8805-44e8-a87f-d87acabc0033", "lat": 12.23423, "lng": 34.345353, "logo": "/uploads/1769186726290-921299469.jpg", "name": "Urlamfdfgdg", "slug": "urla", "email": "asdasdads@gmail.com", "image": "/uploads/1769186731473-757421767.jpg", "phone": "123123", "address": "Maraşel fevzi çakmak mahalessi 4098 sokak no 17", "isActive": true, "whatsapp": "12312", "createdAt": "2026-01-23T06:36:47.391Z", "updatedAt": "2026-01-23T17:19:03.809Z", "description": "aasdsad", "customBanner": null, "primaryColor": "#ceff1f", "successBanner": "/uploads/1769186737785-796155916.jpg"}	{"lat": 12.23423, "lng": 34.345353, "logo": "/uploads/1769186726290-921299469.jpg", "name": "Urlamfdfgdg", "slug": "urla", "email": "asdasdads@gmail.com", "image": "/uploads/1769186731473-757421767.jpg", "phone": "123123", "address": "Maraşel fevzi çakmak mahalessi 4098 sokak no 17", "isActive": true, "whatsapp": "12312", "description": "aasdsad", "customBanner": null, "primaryColor": "#ceff1f", "successBanner": "/uploads/1769186737785-796155916.jpg"}	dde31d5c-b9ef-4f4f-b4f9-95192ec3ea8a	2026-01-23 17:20:22.237		2026-01-23 17:20:05.353	2026-01-23 17:20:22.238
2b462434-66cd-4dd0-97d3-18c0d3879f16	TEACHER_CREATE	APPROVED	aa5d5dba-0088-4074-950f-2f0336190f8b	38aeca3e-8805-44e8-a87f-d87acabc0033	\N	Teacher	\N	{"name": "sdf", "image": "", "subject": "sdfs", "branchId": "38aeca3e-8805-44e8-a87f-d87acabc0033"}	dde31d5c-b9ef-4f4f-b4f9-95192ec3ea8a	2026-01-23 17:20:26.059		2026-01-23 17:20:02.981	2026-01-23 17:20:26.06
e7d6c8b6-981a-4ab2-a4cc-964ce7583dc8	PACKAGE_CREATE	APPROVED	aa5d5dba-0088-4074-950f-2f0336190f8b	38aeca3e-8805-44e8-a87f-d87acabc0033	\N	Package	\N	{"name": "asdsad", "slug": "asdsad", "type": "VIP", "image": null, "isNew": false, "order": 0, "price": 123, "branchId": "38aeca3e-8805-44e8-a87f-d87acabc0033", "discount": null, "duration": "3", "features": null, "isActive": true, "isPopular": false, "videoCount": 123, "description": "dasdsadas", "subjectCount": 123, "originalPrice": null, "shortDescription": "asda"}	dde31d5c-b9ef-4f4f-b4f9-95192ec3ea8a	2026-01-23 19:25:09.363		2026-01-23 17:42:57.143	2026-01-23 19:25:09.364
7a114e06-7f06-46d8-91d0-1e0f632f8b9b	PACKAGE_UPDATE	APPROVED	aa5d5dba-0088-4074-950f-2f0336190f8b	38aeca3e-8805-44e8-a87f-d87acabc0033	7c3284af-b7d7-4d97-a7b6-f2e3a9d837bd	Package	{"id": "7c3284af-b7d7-4d97-a7b6-f2e3a9d837bd", "name": "asdsad", "slug": "asdsad", "type": "VIP", "image": null, "isNew": false, "order": 0, "price": 123, "branchId": "38aeca3e-8805-44e8-a87f-d87acabc0033", "discount": null, "duration": "3", "features": null, "isActive": true, "createdAt": "2026-01-23T19:25:09.356Z", "isPopular": false, "updatedAt": "2026-01-23T19:25:09.356Z", "videoCount": 123, "description": "dasdsadas", "subjectCount": 123, "originalPrice": null, "shortDescription": "asda"}	{"name": "asdsad", "type": "VIP", "price": 123, "duration": "3", "videoCount": 123, "description": "dasdsadas", "subjectCount": 123, "originalPrice": null, "shortDescription": "asda"}	dde31d5c-b9ef-4f4f-b4f9-95192ec3ea8a	2026-01-23 19:32:51.744		2026-01-23 19:32:35.979	2026-01-23 19:32:51.745
32af63bb-824d-4a53-b2ec-f3b981f1e719	PACKAGE_UPDATE	APPROVED	aa5d5dba-0088-4074-950f-2f0336190f8b	38aeca3e-8805-44e8-a87f-d87acabc0033	7c3284af-b7d7-4d97-a7b6-f2e3a9d837bd	Package	{"id": "7c3284af-b7d7-4d97-a7b6-f2e3a9d837bd", "name": "asdsad", "slug": "asdsad", "type": "VIP", "image": null, "isNew": false, "order": 0, "price": 123, "branchId": "38aeca3e-8805-44e8-a87f-d87acabc0033", "discount": null, "duration": "3", "features": null, "isActive": true, "createdAt": "2026-01-23T19:25:09.356Z", "isPopular": false, "updatedAt": "2026-01-23T19:32:51.737Z", "videoCount": 123, "description": "dasdsadas", "subjectCount": 123, "originalPrice": null, "shortDescription": "asda"}	{"name": "asdsad", "type": "VIP", "image": "/uploads/1769196860710-605311159.jpeg", "price": 123, "duration": "3", "videoCount": 123, "description": "dasdsadas", "subjectCount": 123, "originalPrice": null, "shortDescription": "asda"}	dde31d5c-b9ef-4f4f-b4f9-95192ec3ea8a	2026-01-23 19:34:32.257		2026-01-23 19:34:21.341	2026-01-23 19:34:32.258
847807cc-76e1-4832-8229-9adf5c989a02	PACKAGE_UPDATE	APPROVED	aa5d5dba-0088-4074-950f-2f0336190f8b	38aeca3e-8805-44e8-a87f-d87acabc0033	7c3284af-b7d7-4d97-a7b6-f2e3a9d837bd	Package	{"id": "7c3284af-b7d7-4d97-a7b6-f2e3a9d837bd", "name": "asdsad", "slug": "asdsad", "type": "VIP", "image": "/uploads/1769196860710-605311159.jpeg", "isNew": false, "order": 0, "price": 123, "branchId": "38aeca3e-8805-44e8-a87f-d87acabc0033", "discount": null, "duration": "3", "features": null, "isActive": true, "createdAt": "2026-01-23T19:25:09.356Z", "isPopular": false, "updatedAt": "2026-01-23T19:34:32.253Z", "videoCount": 123, "description": "dasdsadas", "subjectCount": 123, "originalPrice": null, "shortDescription": "asda"}	{"name": "asdsad", "type": "VIP", "image": "/uploads/1769196860710-605311159.jpeg", "price": 123, "duration": "3", "videoCount": 123, "description": "dasdsadascvbcbcvb", "subjectCount": 123, "originalPrice": null, "shortDescription": "asda"}	dde31d5c-b9ef-4f4f-b4f9-95192ec3ea8a	2026-01-23 19:40:16.585		2026-01-23 19:40:06.192	2026-01-23 19:40:16.586
b50cf60c-3646-4aba-9217-87b0383aab53	PACKAGE_UPDATE	APPROVED	aa5d5dba-0088-4074-950f-2f0336190f8b	38aeca3e-8805-44e8-a87f-d87acabc0033	7c3284af-b7d7-4d97-a7b6-f2e3a9d837bd	Package	{"id": "7c3284af-b7d7-4d97-a7b6-f2e3a9d837bd", "name": "asdsad", "slug": "asdsad", "type": "VIP", "image": "/uploads/1769196860710-605311159.jpeg", "isNew": false, "order": 0, "price": 123, "branchId": "38aeca3e-8805-44e8-a87f-d87acabc0033", "discount": null, "duration": "3", "features": null, "isActive": true, "createdAt": "2026-01-23T19:25:09.356Z", "isPopular": false, "updatedAt": "2026-01-23T19:40:16.582Z", "videoCount": 123, "description": "dasdsadascvbcbcvb", "subjectCount": 123, "originalPrice": null, "shortDescription": "asda"}	{"name": "asdsad", "type": "VIP", "image": "/uploads/1769196860710-605311159.jpeg", "price": 123, "duration": "3", "videoCount": 123, "description": "dasdsadascvbcbcvb", "subjectCount": 123, "originalPrice": null, "shortDescription": "asdaghjhgjg"}	dde31d5c-b9ef-4f4f-b4f9-95192ec3ea8a	2026-01-23 19:42:19.623		2026-01-23 19:42:12.195	2026-01-23 19:42:19.625
c6c1fdc3-bbf2-46c6-a234-7f9b6eb18b62	BLOG_CREATE	APPROVED	aa5d5dba-0088-4074-950f-2f0336190f8b	38aeca3e-8805-44e8-a87f-d87acabc0033	\N	BlogPost	\N	{"date": "2026-01-24", "image": "/uploads/1769232394145-524907986.jpg", "title": "sadf", "author": "sdfs", "content": "sdfs", "excerpt": "sdfs", "branchId": "38aeca3e-8805-44e8-a87f-d87acabc0033", "category": "Sınav Stratejileri", "isActive": true, "readTime": "5 dk"}	dde31d5c-b9ef-4f4f-b4f9-95192ec3ea8a	2026-01-24 05:31:51.124		2026-01-24 05:31:38.114	2026-01-24 05:31:51.126
da5333cf-f2be-434b-94c4-9fc88ca79f88	BLOG_UPDATE	APPROVED	aa5d5dba-0088-4074-950f-2f0336190f8b	38aeca3e-8805-44e8-a87f-d87acabc0033	2476b016-53ed-473d-a736-17efe367284a	BlogPost	{"id": "2476b016-53ed-473d-a736-17efe367284a", "date": "2026-01-24", "slug": null, "image": "/uploads/1769232394145-524907986.jpg", "title": "sadf", "author": "sdfs", "content": "sdfs", "excerpt": "sdfs", "branchId": "38aeca3e-8805-44e8-a87f-d87acabc0033", "category": "Sınav Stratejileri", "isActive": true, "readTime": "5 dk", "seoTitle": null, "createdAt": "2026-01-24T05:31:51.119Z", "updatedAt": "2026-01-24T05:31:51.119Z", "isFeatured": false, "seoKeywords": null, "seoDescription": null}	{"date": "2026-01-24", "slug": "sdfsds", "image": "/uploads/1769233197982-804208985.jpeg", "title": "sadf", "author": "", "content": "sdfs", "excerpt": "sdfs", "category": "Genel", "isActive": true, "readTime": "5 dk", "seoTitle": "sdfssdf", "isFeatured": true, "seoKeywords": "sdf", "seoDescription": "sdf"}	dde31d5c-b9ef-4f4f-b4f9-95192ec3ea8a	2026-01-24 05:45:46.19		2026-01-24 05:45:34.189	2026-01-24 05:45:46.191
295590f8-9887-499c-8358-7ee6fd2253ab	BLOG_CREATE	APPROVED	aa5d5dba-0088-4074-950f-2f0336190f8b	38aeca3e-8805-44e8-a87f-d87acabc0033	\N	BlogPost	\N	{"date": "2026-01-24", "slug": "dsfs", "image": "/uploads/1769233739099-174388680.png", "title": "sdds", "author": "", "content": "dsfdsfsf", "excerpt": "sdf", "branchId": "38aeca3e-8805-44e8-a87f-d87acabc0033", "category": "Genel", "isActive": true, "readTime": "5 dk", "seoTitle": "xzccz", "isFeatured": true, "seoKeywords": "zxczc", "seoDescription": "zxczc"}	dde31d5c-b9ef-4f4f-b4f9-95192ec3ea8a	2026-01-24 05:49:11.728		2026-01-24 05:49:03.354	2026-01-24 05:49:11.729
f16b25f6-04a3-4bec-abd6-8d365253bd26	BLOG_CREATE	APPROVED	aa5d5dba-0088-4074-950f-2f0336190f8b	38aeca3e-8805-44e8-a87f-d87acabc0033	\N	BlogPost	\N	{"date": "2026-01-24", "slug": "asd", "image": "/uploads/1769233870541-439493620.jpg", "title": "asd", "author": "", "content": "asd", "excerpt": "asd", "branchId": "38aeca3e-8805-44e8-a87f-d87acabc0033", "category": "Genel", "isActive": true, "readTime": "5 dk", "seoTitle": "asd", "isFeatured": false, "seoKeywords": "dasdasdsa", "seoDescription": "as"}	dde31d5c-b9ef-4f4f-b4f9-95192ec3ea8a	2026-01-24 05:51:18.107		2026-01-24 05:51:12.688	2026-01-24 05:51:18.108
309496c0-9563-4851-a59b-0151d0c17aab	BLOG_CREATE	APPROVED	aa5d5dba-0088-4074-950f-2f0336190f8b	38aeca3e-8805-44e8-a87f-d87acabc0033	\N	BlogPost	\N	{"date": "2026-01-24", "slug": "sdfds", "image": "/uploads/1769234095466-834118098.jpg", "title": "sdfdsf", "author": "", "content": "fdsfds", "excerpt": "fsdfs", "branchId": "38aeca3e-8805-44e8-a87f-d87acabc0033", "category": "Genel", "isActive": true, "readTime": "5 dk", "seoTitle": "sdfsf", "isFeatured": true, "seoKeywords": "sdfds", "seoDescription": "sdfs"}	dde31d5c-b9ef-4f4f-b4f9-95192ec3ea8a	2026-01-24 06:18:58.038	dsfsds	2026-01-24 05:54:58.858	2026-01-24 06:18:58.039
5036bafe-5cc0-4b5f-84e1-81c6bf9d73bc	BLOG_CREATE	APPROVED	aa5d5dba-0088-4074-950f-2f0336190f8b	38aeca3e-8805-44e8-a87f-d87acabc0033	\N	BlogPost	\N	{"date": "2026-01-24", "slug": "asdas", "image": "/uploads/1769233957467-942737813.jpg", "title": "asd", "author": "", "content": "asda", "excerpt": "asd", "branchId": "38aeca3e-8805-44e8-a87f-d87acabc0033", "category": "Genel", "isActive": true, "readTime": "5 dk", "seoTitle": "asda", "isFeatured": true, "seoKeywords": "dasdada", "seoDescription": "dasd"}	dde31d5c-b9ef-4f4f-b4f9-95192ec3ea8a	2026-01-24 06:18:59.919		2026-01-24 05:52:38.871	2026-01-24 06:18:59.919
41de54d1-f5b2-4ea4-a0bd-516d3553c77e	BLOG_CREATE	APPROVED	aa5d5dba-0088-4074-950f-2f0336190f8b	38aeca3e-8805-44e8-a87f-d87acabc0033	\N	BlogPost	\N	{"date": "2026-01-24", "slug": "dsfdssdfs", "image": "/uploads/1769235780335-647407962.jpg", "title": "sdfds", "author": "", "content": "sdfdsfso", "excerpt": "fsdfdsfds", "branchId": "38aeca3e-8805-44e8-a87f-d87acabc0033", "category": "Genel", "isActive": true, "readTime": "5 dk", "seoTitle": "sdfsfs", "isFeatured": true, "seoKeywords": "dssdfsfdsfdsfdsfs", "seoDescription": "ssdfdsf"}	dde31d5c-b9ef-4f4f-b4f9-95192ec3ea8a	2026-01-24 06:23:18.16		2026-01-24 06:23:03.809	2026-01-24 06:23:18.161
cf84b169-6bc2-436a-9d17-cd37207f3186	BLOG_DELETE	APPROVED	aa5d5dba-0088-4074-950f-2f0336190f8b	38aeca3e-8805-44e8-a87f-d87acabc0033	30b1fe2f-1d9f-485c-9770-8d7510fafccd	BlogPost	{"id": "30b1fe2f-1d9f-485c-9770-8d7510fafccd", "date": "2026-01-24", "slug": "asdas", "image": "/uploads/1769233957467-942737813.jpg", "title": "asd", "author": "", "content": "asda", "excerpt": "asd", "branchId": "38aeca3e-8805-44e8-a87f-d87acabc0033", "category": "Genel", "isActive": true, "readTime": "5 dk", "seoTitle": "asda", "createdAt": "2026-01-24T06:18:59.913Z", "updatedAt": "2026-01-24T06:18:59.913Z", "isFeatured": true, "publishedAt": null, "seoKeywords": "dasdada", "seoDescription": "dasd"}	{"deleted": true}	dde31d5c-b9ef-4f4f-b4f9-95192ec3ea8a	2026-01-24 11:00:44.979		2026-01-24 11:00:36.343	2026-01-24 11:00:44.98
06fd9c9c-9ca3-4a37-ae46-bd029c1229a2	BLOG_DELETE	APPROVED	aa5d5dba-0088-4074-950f-2f0336190f8b	38aeca3e-8805-44e8-a87f-d87acabc0033	9d10c0e1-d509-4071-94e9-37b07be1733a	BlogPost	{"id": "9d10c0e1-d509-4071-94e9-37b07be1733a", "date": "2026-01-24", "slug": "sdfds", "image": "/uploads/1769234095466-834118098.jpg", "title": "sdfdsf", "author": "", "content": "fdsfds", "excerpt": "fsdfs", "branchId": "38aeca3e-8805-44e8-a87f-d87acabc0033", "category": "Genel", "isActive": true, "readTime": "5 dk", "seoTitle": "sdfsf", "createdAt": "2026-01-24T06:18:58.035Z", "updatedAt": "2026-01-24T06:18:58.035Z", "isFeatured": true, "publishedAt": null, "seoKeywords": "sdfds", "seoDescription": "sdfs"}	{"deleted": true}	dde31d5c-b9ef-4f4f-b4f9-95192ec3ea8a	2026-01-24 11:01:05.074		2026-01-24 11:00:57.946	2026-01-24 11:01:05.074
5faef013-5fb1-4484-93ab-06bfdbc55700	SUCCESS_CREATE	REJECTED	aa5d5dba-0088-4074-950f-2f0336190f8b	38aeca3e-8805-44e8-a87f-d87acabc0033	\N	YearlySuccess	\N	{"year": "2026", "banner": {"image": "/uploads/1769255584692-959558239.jpg", "title": "SDFDS", "subtitle": "SDFSFDSFD", "description": "ASDASDADSAD"}, "branchId": "38aeca3e-8805-44e8-a87f-d87acabc0033", "cityCount": 0, "lgsAverage": 2342, "yksAverage": 3453, "successRate": 22, "top100Count": 23, "top1000Count": 123, "totalDegrees": 123, "placementCount": 123}	dde31d5c-b9ef-4f4f-b4f9-95192ec3ea8a	2026-01-24 12:01:04.705		2026-01-24 11:53:05.094	2026-01-24 12:01:04.706
a5d50129-4105-40db-9136-1c91a2ba8764	STUDENT_CREATE	APPROVED	aa5d5dba-0088-4074-950f-2f0336190f8b	38aeca3e-8805-44e8-a87f-d87acabc0033	3fa03375-ecac-4b2a-ba6e-e767dcb90388	TopStudent	\N	{"exam": "YKS", "name": "sdfs", "rank": "123", "image": "/uploads/1769258683025-81945106.jpg", "order": 1, "score": 12333, "branch": "BİLGİ", "university": "ASDAAD", "yearlySuccessId": "3fa03375-ecac-4b2a-ba6e-e767dcb90388"}	dde31d5c-b9ef-4f4f-b4f9-95192ec3ea8a	2026-01-24 12:46:27.768		2026-01-24 12:44:43.411	2026-01-24 12:46:27.769
12cb1900-8d4b-4af1-aa4f-8ee247231fae	SUCCESS_CREATE	APPROVED	aa5d5dba-0088-4074-950f-2f0336190f8b	38aeca3e-8805-44e8-a87f-d87acabc0033	\N	YearlySuccess	\N	{"year": "2025", "banner": {"image": "/uploads/1769258997807-5407244.jpg", "title": "SDFS", "subtitle": "SDFFSF", "description": "ASDAD"}, "branchId": "38aeca3e-8805-44e8-a87f-d87acabc0033", "cityCount": 0, "lgsAverage": 123, "yksAverage": 123, "successRate": 123, "top100Count": 123, "top1000Count": 123, "totalDegrees": 123, "placementCount": 123}	dde31d5c-b9ef-4f4f-b4f9-95192ec3ea8a	2026-01-24 12:50:12.809		2026-01-24 12:50:02.406	2026-01-24 12:50:12.81
062013f5-ed5f-4849-a3c8-f22e93e9d5a5	BLOG_CREATE	APPROVED	aa5d5dba-0088-4074-950f-2f0336190f8b	38aeca3e-8805-44e8-a87f-d87acabc0033	\N	BlogPost	\N	{"date": "2026-01-24", "slug": "sf", "image": "/uploads/1769270940079-580302749.jpg", "title": "dsf", "author": "", "content": "sdfsfdsf", "excerpt": "sdfdsdssf", "branchId": "38aeca3e-8805-44e8-a87f-d87acabc0033", "category": "Genel", "isActive": true, "readTime": "5 dk", "seoTitle": "ssdfs", "isFeatured": true, "seoKeywords": "fsdfdsfs", "seoDescription": "dfdsfdsf"}	dde31d5c-b9ef-4f4f-b4f9-95192ec3ea8a	2026-01-24 16:09:10.313		2026-01-24 16:09:04.217	2026-01-24 16:09:10.314
2076557f-d2e2-4245-96be-6e7bdf98d015	STUDENT_CREATE	APPROVED	aa5d5dba-0088-4074-950f-2f0336190f8b	38aeca3e-8805-44e8-a87f-d87acabc0033	3fa03375-ecac-4b2a-ba6e-e767dcb90388	TopStudent	\N	{"exam": "YKS", "name": "ferit", "rank": "32", "image": "/uploads/1769407729709-784261839.jpg", "order": 2, "score": 452, "branch": "BİLGİ", "university": "BAOGAZ", "yearlySuccessId": "3fa03375-ecac-4b2a-ba6e-e767dcb90388"}	dde31d5c-b9ef-4f4f-b4f9-95192ec3ea8a	2026-01-26 06:09:12.871		2026-01-26 06:08:50.169	2026-01-26 06:09:12.872
9381d57e-06cb-4a21-aaff-6ca09ad7bdfb	TEACHER_DELETE	APPROVED	aa5d5dba-0088-4074-950f-2f0336190f8b	38aeca3e-8805-44e8-a87f-d87acabc0033	2fc0cb98-4fb4-4e40-ab3b-17037b597b0e	Teacher	{"id": "2fc0cb98-4fb4-4e40-ab3b-17037b597b0e", "name": "sdf", "image": "", "order": 0, "subject": "sdfs", "branchId": "38aeca3e-8805-44e8-a87f-d87acabc0033", "isActive": true, "createdAt": "2026-01-23T17:20:26.055Z", "updatedAt": "2026-01-23T17:20:26.055Z"}	{"deleted": true}	dde31d5c-b9ef-4f4f-b4f9-95192ec3ea8a	2026-01-26 06:09:16.002		2026-01-26 06:08:22.714	2026-01-26 06:09:16.003
15f3cf56-0759-4fdd-8d90-d2465c8505e9	TEACHER_DELETE	APPROVED	aa5d5dba-0088-4074-950f-2f0336190f8b	38aeca3e-8805-44e8-a87f-d87acabc0033	4c73259e-ccb7-4472-a338-d2d01158d3d9	Teacher	{"id": "4c73259e-ccb7-4472-a338-d2d01158d3d9", "name": "dfgdg", "image": "", "order": 0, "subject": "dfgdgdg", "branchId": "38aeca3e-8805-44e8-a87f-d87acabc0033", "isActive": true, "createdAt": "2026-01-23T17:19:11.867Z", "updatedAt": "2026-01-23T17:19:11.867Z"}	{"deleted": true}	dde31d5c-b9ef-4f4f-b4f9-95192ec3ea8a	2026-01-26 06:09:18.805		2026-01-26 06:08:26.041	2026-01-26 06:09:18.806
660a85d1-6e3b-4804-ba85-a6b5e2c3f6a3	PACKAGE_DELETE	APPROVED	aa5d5dba-0088-4074-950f-2f0336190f8b	38aeca3e-8805-44e8-a87f-d87acabc0033	f20068e8-19ec-4a09-9fef-e08eee9b4fe2	Package	{"id": "f20068e8-19ec-4a09-9fef-e08eee9b4fe2", "name": "FSDFSF", "slug": "fsdfsf", "type": "VIP", "image": "/uploads/1769410344192-721385187.jpg", "isNew": true, "order": 0, "price": 123, "branchId": "38aeca3e-8805-44e8-a87f-d87acabc0033", "discount": 32, "duration": "123", "features": ["SDFSF", "SDF"], "isActive": true, "createdAt": "2026-01-26T06:52:32.935Z", "isPopular": true, "updatedAt": "2026-01-26T06:52:32.935Z", "videoCount": 123, "description": "FSFSFS", "subjectCount": 123, "originalPrice": 123, "shortDescription": "SDFS"}	{"deleted": true}	dde31d5c-b9ef-4f4f-b4f9-95192ec3ea8a	2026-01-26 07:43:58.403		2026-01-26 07:43:50.143	2026-01-26 07:43:58.404
47ef24e0-1a2b-42a6-b457-8ff3bf7d0cd7	PACKAGE_DELETE	REJECTED	aa5d5dba-0088-4074-950f-2f0336190f8b	38aeca3e-8805-44e8-a87f-d87acabc0033	9f3b11c2-2a34-490b-acf8-531875712c2c	Package	{"id": "9f3b11c2-2a34-490b-acf8-531875712c2c", "name": "selamlar", "slug": "selamlar", "type": "VIP", "image": "/uploads/1769409495650-16554277.jpg", "isNew": true, "order": 4, "price": 123, "branchId": "38aeca3e-8805-44e8-a87f-d87acabc0033", "discount": 23, "duration": "3", "features": ["asdada"], "isActive": true, "createdAt": "2026-01-26T06:47:22.350Z", "isPopular": true, "updatedAt": "2026-01-26T06:51:33.767Z", "videoCount": 123, "description": "aasdada", "subjectCount": 123, "originalPrice": 1233, "shortDescription": "asdasd"}	{"deleted": true}	dde31d5c-b9ef-4f4f-b4f9-95192ec3ea8a	2026-01-26 07:54:54.945		2026-01-26 07:54:48.815	2026-01-26 07:54:54.946
75f272e0-cbb4-4edb-be6f-b7dddefa752e	SUCCESS_CREATE	APPROVED	aa5d5dba-0088-4074-950f-2f0336190f8b	38aeca3e-8805-44e8-a87f-d87acabc0033	\N	YearlySuccess	\N	{"year": "2025", "banner": {"image": "/uploads/1769415153123-689083399.jpg", "title": "ASDSA", "subtitle": "ASADAD", "gradientTo": "#1e40af", "description": "ASDASD", "gradientFrom": "#2563eb", "highlightText": null}, "branchId": "38aeca3e-8805-44e8-a87f-d87acabc0033", "cityCount": 0, "lgsAverage": 123, "yksAverage": 123, "successRate": 123, "top100Count": 123, "top1000Count": 123, "totalDegrees": 123, "placementCount": 123}	dde31d5c-b9ef-4f4f-b4f9-95192ec3ea8a	2026-01-26 08:15:18.781		2026-01-26 08:12:34.146	2026-01-26 08:15:18.782
e11cf7d6-1603-41b8-af00-1136f562d519	BRANCH_UPDATE	APPROVED	aa5d5dba-0088-4074-950f-2f0336190f8b	38aeca3e-8805-44e8-a87f-d87acabc0033	38aeca3e-8805-44e8-a87f-d87acabc0033	Branch	{"id": "38aeca3e-8805-44e8-a87f-d87acabc0033", "lat": 12.23423, "lng": 34.345353, "logo": "/uploads/1769186726290-921299469.jpg", "name": "Urlamfdfgdg", "slug": "urla", "email": "asdasdads@gmail.com", "image": "/uploads/1769186731473-757421767.jpg", "phone": "123123", "address": "Maraşel fevzi çakmak mahalessi 4098 sokak no 17", "isActive": true, "whatsapp": "12312", "createdAt": "2026-01-23T06:36:47.391Z", "updatedAt": "2026-01-23T17:20:22.233Z", "description": "aasdsad", "customBanner": null, "primaryColor": "#ceff1f", "successBanner": "/uploads/1769186737785-796155916.jpg"}	{"lat": 12.23423, "lng": 34.345353, "logo": "/uploads/1769407738350-222638415.jpeg", "name": "Urlamfdfgdg", "slug": "urla", "email": "asdasdads@gmail.com", "image": "/uploads/1769186731473-757421767.jpg", "phone": "123123", "address": "Maraşel fevzi çakmak mahalessi 4098 sokak no 17", "isActive": true, "whatsapp": "12312", "description": "aasdsad", "customBanner": null, "primaryColor": "#ceff1f", "successBanner": "/uploads/1769186737785-796155916.jpg"}	dde31d5c-b9ef-4f4f-b4f9-95192ec3ea8a	2026-01-26 06:09:09.484		2026-01-26 06:08:59.139	2026-01-26 06:09:09.485
87391066-9fbe-44da-b211-440d3b3697bd	BRANCH_UPDATE	APPROVED	aa5d5dba-0088-4074-950f-2f0336190f8b	38aeca3e-8805-44e8-a87f-d87acabc0033	38aeca3e-8805-44e8-a87f-d87acabc0033	Branch	{"id": "38aeca3e-8805-44e8-a87f-d87acabc0033", "lat": 12.23423, "lng": 34.345353, "logo": "/uploads/1769407738350-222638415.jpeg", "name": "Urlamfdfgdg", "slug": "urla", "email": "asdasdads@gmail.com", "image": "/uploads/1769186731473-757421767.jpg", "phone": "123123", "address": "Maraşel fevzi çakmak mahalessi 4098 sokak no 17", "isActive": true, "whatsapp": "12312", "createdAt": "2026-01-23T06:36:47.391Z", "updatedAt": "2026-01-26T06:09:09.476Z", "description": "aasdsad", "customBanner": null, "primaryColor": "#ceff1f", "successBanner": "/uploads/1769186737785-796155916.jpg"}	{"lat": 12.23423, "lng": 34.345353, "logo": "/uploads/1769407738350-222638415.jpeg", "name": "Urlam", "slug": "urla", "email": "asdasdads@gmail.com", "image": "/uploads/1769186731473-757421767.jpg", "phone": "123123", "address": "Maraşel fevzi çakmak mahalessi 4098 sokak no 17", "isActive": true, "whatsapp": "12312", "description": "aasdsad", "customBanner": null, "primaryColor": "#ceff1f", "successBanner": "/uploads/1769186737785-796155916.jpg"}	dde31d5c-b9ef-4f4f-b4f9-95192ec3ea8a	2026-01-26 06:09:33.246		2026-01-26 06:09:29.442	2026-01-26 06:09:33.247
2b2f41b1-ed96-4f43-b69b-dcdf279717d2	BRANCH_UPDATE	APPROVED	aa5d5dba-0088-4074-950f-2f0336190f8b	38aeca3e-8805-44e8-a87f-d87acabc0033	38aeca3e-8805-44e8-a87f-d87acabc0033	Branch	{"id": "38aeca3e-8805-44e8-a87f-d87acabc0033", "lat": 12.23423, "lng": 34.345353, "logo": "/uploads/1769407738350-222638415.jpeg", "name": "Urlam", "slug": "urla", "email": "asdasdads@gmail.com", "image": "/uploads/1769186731473-757421767.jpg", "phone": "123123", "address": "Maraşel fevzi çakmak mahalessi 4098 sokak no 17", "isActive": true, "whatsapp": "12312", "createdAt": "2026-01-23T06:36:47.391Z", "updatedAt": "2026-01-26T06:09:33.243Z", "description": "aasdsad", "customBanner": null, "primaryColor": "#ceff1f", "successBanner": "/uploads/1769186737785-796155916.jpg"}	{"lat": 12.23423, "lng": 34.345353, "logo": "/uploads/1769407738350-222638415.jpeg", "name": "Urla", "slug": "urla", "email": "asdasdads@gmail.com", "image": "/uploads/1769186731473-757421767.jpg", "phone": "123123", "address": "Maraşel fevzi çakmak mahalessi 4098 sokak no 17", "isActive": true, "whatsapp": "12312", "description": "aasdsad", "customBanner": null, "primaryColor": "#ceff1f", "successBanner": "/uploads/1769186737785-796155916.jpg"}	dde31d5c-b9ef-4f4f-b4f9-95192ec3ea8a	2026-01-26 06:09:44.693		2026-01-26 06:09:40.598	2026-01-26 06:09:44.694
b7288b5f-d8f3-436c-955a-a0d6cbf98fef	BRANCH_UPDATE	APPROVED	aa5d5dba-0088-4074-950f-2f0336190f8b	38aeca3e-8805-44e8-a87f-d87acabc0033	38aeca3e-8805-44e8-a87f-d87acabc0033	Branch	{"id": "38aeca3e-8805-44e8-a87f-d87acabc0033", "lat": 12.23423, "lng": 34.345353, "logo": "/uploads/1769407738350-222638415.jpeg", "name": "Urla", "slug": "urla", "email": "asdasdads@gmail.com", "image": "/uploads/1769186731473-757421767.jpg", "phone": "123123", "address": "Maraşel fevzi çakmak mahalessi 4098 sokak no 17", "isActive": true, "whatsapp": "12312", "createdAt": "2026-01-23T06:36:47.391Z", "updatedAt": "2026-01-26T06:09:44.687Z", "description": "aasdsad", "customBanner": null, "primaryColor": "#ceff1f", "successBanner": "/uploads/1769186737785-796155916.jpg"}	{"lat": 12.23423, "lng": 34.345353, "logo": "/uploads/1769407738350-222638415.jpeg", "name": "UrlA", "slug": "urla", "email": "asdasdads@gmail.com3", "image": "/uploads/1769186731473-757421767.jpg", "phone": "123123323", "address": "Maraşel fevzi çakmak mahalessi 4098 sokak no 17D", "isActive": true, "whatsapp": "12312", "description": "aasdsad", "customBanner": null, "primaryColor": "#ceff1f", "successBanner": "/uploads/1769186737785-796155916.jpg"}	dde31d5c-b9ef-4f4f-b4f9-95192ec3ea8a	2026-01-26 06:10:09.453		2026-01-26 06:10:02.601	2026-01-26 06:10:09.454
788699df-a62d-4802-827f-ec4c5f4f72dc	BRANCH_UPDATE	APPROVED	aa5d5dba-0088-4074-950f-2f0336190f8b	38aeca3e-8805-44e8-a87f-d87acabc0033	38aeca3e-8805-44e8-a87f-d87acabc0033	Branch	{"id": "38aeca3e-8805-44e8-a87f-d87acabc0033", "lat": 12.23423, "lng": 34.345353, "logo": "/uploads/1769407738350-222638415.jpeg", "name": "UrlA", "slug": "urla", "email": "asdasdads@gmail.com3", "image": "/uploads/1769186731473-757421767.jpg", "phone": "123123323", "address": "Maraşel fevzi çakmak mahalessi 4098 sokak no 17D", "isActive": true, "whatsapp": "12312", "createdAt": "2026-01-23T06:36:47.391Z", "updatedAt": "2026-01-26T06:10:09.452Z", "description": "aasdsad", "customBanner": null, "primaryColor": "#ceff1f", "successBanner": "/uploads/1769186737785-796155916.jpg"}	{"lat": 12.23423, "lng": 34.345353, "logo": "/uploads/1769407738350-222638415.jpeg", "name": "UrlAdfds", "slug": "urla", "email": "asdasdads@gmail.com3", "image": "/uploads/1769186731473-757421767.jpg", "phone": "123123323", "address": "Maraşel fevzi çakmak mahalessi 4098 sokak no 17D", "isActive": true, "whatsapp": "12312", "description": "aasdsad", "customBanner": null, "primaryColor": "#ceff1f", "successBanner": "/uploads/1769186737785-796155916.jpg"}	dde31d5c-b9ef-4f4f-b4f9-95192ec3ea8a	2026-01-26 06:13:56.728		2026-01-26 06:13:42.337	2026-01-26 06:13:56.73
5a8c2eca-0aa5-45df-abd6-03cd7dad9f55	BRANCH_UPDATE	REJECTED	aa5d5dba-0088-4074-950f-2f0336190f8b	38aeca3e-8805-44e8-a87f-d87acabc0033	38aeca3e-8805-44e8-a87f-d87acabc0033	Branch	{"id": "38aeca3e-8805-44e8-a87f-d87acabc0033", "lat": 12.23423, "lng": 34.345353, "logo": "/uploads/1769407738350-222638415.jpeg", "name": "UrlAdfds", "slug": "urla", "email": "asdasdads@gmail.com3", "image": "/uploads/1769186731473-757421767.jpg", "phone": "123123323", "address": "Maraşel fevzi çakmak mahalessi 4098 sokak no 17D", "isActive": true, "whatsapp": "12312", "createdAt": "2026-01-23T06:36:47.391Z", "updatedAt": "2026-01-26T06:13:56.719Z", "description": "aasdsad", "customBanner": null, "primaryColor": "#ceff1f", "successBanner": "/uploads/1769186737785-796155916.jpg"}	{"lat": 12.23423, "lng": 34.345353, "logo": "/uploads/1769407738350-222638415.jpeg", "name": "UrlAdfdsdsfs", "slug": "urla", "email": "asdasdads@gmail.com3", "image": "/uploads/1769186731473-757421767.jpg", "phone": "123123323", "address": "Maraşel fevzi çakmak mahalessi 4098 sokak no 17D", "isActive": true, "whatsapp": "12312", "description": "aasdsadsdfs", "customBanner": null, "primaryColor": "#ceff1f", "successBanner": "/uploads/1769186737785-796155916.jpg"}	dde31d5c-b9ef-4f4f-b4f9-95192ec3ea8a	2026-01-26 06:16:23.948		2026-01-26 06:15:22.801	2026-01-26 06:16:23.949
70f6eab3-a2c9-43ee-bc5a-184b192568dc	BRANCH_UPDATE	APPROVED	aa5d5dba-0088-4074-950f-2f0336190f8b	38aeca3e-8805-44e8-a87f-d87acabc0033	38aeca3e-8805-44e8-a87f-d87acabc0033	Branch	{"id": "38aeca3e-8805-44e8-a87f-d87acabc0033", "lat": 12.23423, "lng": 34.345353, "logo": "/uploads/1769407738350-222638415.jpeg", "name": "UrlAdfds", "slug": "urla", "email": "asdasdads@gmail.com3", "image": "/uploads/1769186731473-757421767.jpg", "phone": "123123323", "address": "Maraşel fevzi çakmak mahalessi 4098 sokak no 17D", "isActive": true, "whatsapp": "12312", "createdAt": "2026-01-23T06:36:47.391Z", "updatedAt": "2026-01-26T06:13:56.719Z", "description": "aasdsad", "customBanner": null, "primaryColor": "#ceff1f", "successBanner": "/uploads/1769186737785-796155916.jpg"}	{"lat": 12.23423, "lng": 34.345353, "logo": "/uploads/1769407738350-222638415.jpeg", "name": "UrlAdfds", "slug": "urla", "email": "asdasdads@gmail.com3", "image": "/uploads/1769186731473-757421767.jpg", "phone": "123123323", "address": "Maraşel fevzi çakmak mahalessi 4098 sokak no 17D", "isActive": true, "whatsapp": "12312", "description": "aasdsad", "customBanner": null, "primaryColor": "#ceff1f", "successBanner": "/uploads/1769186737785-796155916.jpg"}	dde31d5c-b9ef-4f4f-b4f9-95192ec3ea8a	2026-01-26 06:21:43.028		2026-01-26 06:20:38.249	2026-01-26 06:21:43.029
f0f39356-4beb-4cd6-ab2d-37ef2d4f21a2	BRANCH_UPDATE	APPROVED	aa5d5dba-0088-4074-950f-2f0336190f8b	38aeca3e-8805-44e8-a87f-d87acabc0033	38aeca3e-8805-44e8-a87f-d87acabc0033	Branch	{"id": "38aeca3e-8805-44e8-a87f-d87acabc0033", "lat": 12.23423, "lng": 34.345353, "logo": "/uploads/1769407738350-222638415.jpeg", "name": "UrlAdfds", "slug": "urla", "email": "asdasdads@gmail.com3", "image": "/uploads/1769186731473-757421767.jpg", "phone": "123123323", "address": "Maraşel fevzi çakmak mahalessi 4098 sokak no 17D", "isActive": true, "whatsapp": "12312", "createdAt": "2026-01-23T06:36:47.391Z", "updatedAt": "2026-01-26T06:21:43.023Z", "description": "aasdsad", "customBanner": null, "primaryColor": "#ceff1f", "successBanner": "/uploads/1769186737785-796155916.jpg"}	{"lat": 12.23423, "lng": 34.345353, "logo": "/uploads/1769407738350-222638415.jpeg", "name": "UrlAdfds", "slug": "urla", "email": "asdasdads@gmail.com3", "image": "/uploads/1769186731473-757421767.jpg", "phone": "123123323", "address": "Maraşel fevzi çakmak mahalessi 4098 sokak no 17D", "isActive": true, "whatsapp": "12312", "description": "aasdsad", "customBanner": null, "primaryColor": "#ceff1f", "successBanner": "/uploads/1769186737785-796155916.jpg"}	dde31d5c-b9ef-4f4f-b4f9-95192ec3ea8a	2026-01-26 06:23:52.967		2026-01-26 06:22:11.764	2026-01-26 06:23:52.967
5e9906ff-e31b-4358-9f39-d759ce5033ce	BRANCH_UPDATE	APPROVED	aa5d5dba-0088-4074-950f-2f0336190f8b	38aeca3e-8805-44e8-a87f-d87acabc0033	38aeca3e-8805-44e8-a87f-d87acabc0033	Branch	{"id": "38aeca3e-8805-44e8-a87f-d87acabc0033", "lat": 12.23423, "lng": 34.345353, "logo": "/uploads/1769407738350-222638415.jpeg", "name": "UrlAdfds", "slug": "urla", "email": "asdasdads@gmail.com3", "image": "/uploads/1769186731473-757421767.jpg", "phone": "123123323", "address": "Maraşel fevzi çakmak mahalessi 4098 sokak no 17D", "isActive": true, "whatsapp": "12312", "createdAt": "2026-01-23T06:36:47.391Z", "updatedAt": "2026-01-26T06:23:52.964Z", "description": "aasdsad", "customBanner": null, "primaryColor": "#ceff1f", "weekdayHours": "08:30 - 19:30", "weekendHours": "09:00 - 18:00", "successBanner": "/uploads/1769186737785-796155916.jpg"}	{"lat": 12.23423, "lng": 34.345353, "logo": "/uploads/1769407738350-222638415.jpeg", "name": "UrlAdfds", "slug": "urla", "email": "asdasdads@gmail.com3", "image": "/uploads/1769186731473-757421767.jpg", "phone": "123123323", "address": "Maraşel fevzi çakmak mahalessi 4098 sokak no 17D", "isActive": true, "whatsapp": "12312", "description": "aasdsad", "customBanner": null, "primaryColor": "#ceff1f", "weekdayHours": "08:30 - 19:33", "weekendHours": "09:00 - 18:05", "successBanner": "/uploads/1769186737785-796155916.jpg"}	dde31d5c-b9ef-4f4f-b4f9-95192ec3ea8a	2026-01-26 06:24:07.73		2026-01-26 06:24:02.984	2026-01-26 06:24:07.731
3a56ae37-e1f1-4e36-9ed2-334e0774beb6	PACKAGE_DELETE	APPROVED	aa5d5dba-0088-4074-950f-2f0336190f8b	38aeca3e-8805-44e8-a87f-d87acabc0033	31a6eb82-a093-4214-aeda-9b222fb60a9a	Package	{"id": "31a6eb82-a093-4214-aeda-9b222fb60a9a", "name": "test", "slug": "test", "type": "VIP", "image": "/uploads/1769409260491-942423281.jpg", "isNew": false, "order": 0, "price": 123, "branchId": "38aeca3e-8805-44e8-a87f-d87acabc0033", "discount": null, "duration": "6", "features": null, "isActive": true, "createdAt": "2026-01-26T06:34:28.964Z", "isPopular": false, "updatedAt": "2026-01-26T06:51:33.767Z", "videoCount": 100, "description": "selamlarselamlarselamlarselamlar", "subjectCount": 45, "originalPrice": 150, "shortDescription": "selamlar"}	{"deleted": true}	dde31d5c-b9ef-4f4f-b4f9-95192ec3ea8a	2026-01-26 07:43:59.751		2026-01-26 07:43:43.518	2026-01-26 07:43:59.752
ba4a95a8-86c5-4a8e-98ef-bb2ac0781940	SUCCESS_DELETE	APPROVED	aa5d5dba-0088-4074-950f-2f0336190f8b	38aeca3e-8805-44e8-a87f-d87acabc0033	2fb0ecdb-20ca-481f-acca-f4fac8e05910	YearlySuccess	{"id": "2fb0ecdb-20ca-481f-acca-f4fac8e05910", "year": "2025", "banner": {"id": "b68e82fc-4cdc-4a7d-946f-a9c4516e913c", "image": "/uploads/1769258997807-5407244.jpg", "title": "SDFS", "subtitle": "SDFFSF", "gradientTo": "#1e40af", "description": "ASDAD", "gradientFrom": "#2563eb", "highlightText": null, "yearlySuccessId": "2fb0ecdb-20ca-481f-acca-f4fac8e05910"}, "branchId": "38aeca3e-8805-44e8-a87f-d87acabc0033", "isActive": true, "students": [], "cityCount": 0, "createdAt": "2026-01-24T12:50:12.797Z", "updatedAt": "2026-01-24T12:50:12.797Z", "lgsAverage": 123, "yksAverage": 123, "successRate": 123, "top100Count": 123, "top1000Count": 123, "totalDegrees": 123, "placementCount": 123}	{"deleted": true}	dde31d5c-b9ef-4f4f-b4f9-95192ec3ea8a	2026-01-26 08:08:45.093		2026-01-26 08:08:37.481	2026-01-26 08:08:45.094
cd09e1b9-9f8e-425c-811d-8a2ea30f62d8	SUCCESS_CREATE	REJECTED	aa5d5dba-0088-4074-950f-2f0336190f8b	38aeca3e-8805-44e8-a87f-d87acabc0033	\N	YearlySuccess	\N	{"year": "2025", "banner": {"image": "/uploads/1769414965060-483627030.jpg", "title": "ASDSA", "subtitle": "ASDSADASD", "description": "ASDAD"}, "branchId": "38aeca3e-8805-44e8-a87f-d87acabc0033", "cityCount": 0, "lgsAverage": 123123, "yksAverage": 342, "successRate": 23, "top100Count": 12, "top1000Count": 123, "totalDegrees": 123, "placementCount": 123}	dde31d5c-b9ef-4f4f-b4f9-95192ec3ea8a	2026-01-26 08:12:10.354		2026-01-26 08:09:26.189	2026-01-26 08:12:10.355
637dfd13-7133-42bd-88cb-361982989b37	BRANCH_UPDATE	APPROVED	aa5d5dba-0088-4074-950f-2f0336190f8b	38aeca3e-8805-44e8-a87f-d87acabc0033	38aeca3e-8805-44e8-a87f-d87acabc0033	Branch	{"id": "38aeca3e-8805-44e8-a87f-d87acabc0033", "lat": 12.23423, "lng": 34.345353, "logo": "/uploads/1769407738350-222638415.jpeg", "name": "UrlAdfds", "slug": "urla", "email": "asdasdads@gmail.com3", "image": "/uploads/1769186731473-757421767.jpg", "phone": "123123323", "address": "Maraşel fevzi çakmak mahalessi 4098 sokak no 17D", "features": null, "isActive": true, "whatsapp": "12312", "createdAt": "2026-01-23T06:36:47.391Z", "updatedAt": "2026-01-26T06:24:07.724Z", "description": "aasdsad", "customBanner": null, "primaryColor": "#ceff1f", "weekdayHours": "08:30 - 19:33", "weekendHours": "09:00 - 18:05", "successBanner": "/uploads/1769186737785-796155916.jpg"}	{"lat": 12.23423, "lng": 34.345353, "logo": "/uploads/1769407738350-222638415.jpeg", "name": "UrlAdfds", "slug": "urla", "email": "asdasdads@gmail.com3", "image": "/uploads/1769186731473-757421767.jpg", "phone": "123123323", "address": "Maraşel fevzi çakmak mahalessi 4098 sokak no 17D", "features": [{"icon": "Calendar", "text": "selamlar"}], "isActive": true, "whatsapp": "12312", "description": "aasdsad", "customBanner": null, "primaryColor": "#ceff1f", "weekdayHours": "08:30 - 19:33", "weekendHours": "09:00 - 18:05", "successBanner": "/uploads/1769186737785-796155916.jpg"}	dde31d5c-b9ef-4f4f-b4f9-95192ec3ea8a	2026-01-26 06:30:43.885		2026-01-26 06:30:37.915	2026-01-26 06:30:43.886
2455c46c-caad-484d-805b-3cce7ecbc84d	BRANCH_UPDATE	APPROVED	aa5d5dba-0088-4074-950f-2f0336190f8b	38aeca3e-8805-44e8-a87f-d87acabc0033	38aeca3e-8805-44e8-a87f-d87acabc0033	Branch	{"id": "38aeca3e-8805-44e8-a87f-d87acabc0033", "lat": 12.23423, "lng": 34.345353, "logo": "/uploads/1769407738350-222638415.jpeg", "name": "UrlAdfds", "slug": "urla", "email": "asdasdads@gmail.com3", "image": "/uploads/1769186731473-757421767.jpg", "phone": "123123323", "address": "Maraşel fevzi çakmak mahalessi 4098 sokak no 17D", "features": [{"icon": "Calendar", "text": "selamlar"}], "isActive": true, "whatsapp": "12312", "createdAt": "2026-01-23T06:36:47.391Z", "updatedAt": "2026-01-26T06:30:43.879Z", "description": "aasdsad", "customBanner": null, "primaryColor": "#ceff1f", "weekdayHours": "08:30 - 19:33", "weekendHours": "09:00 - 18:05", "successBanner": "/uploads/1769186737785-796155916.jpg"}	{"lat": 12.23423, "lng": 34.345353, "logo": "/uploads/1769407738350-222638415.jpeg", "name": "UrlAdfds", "slug": "urla", "email": "asdasdads@gmail.com3", "image": "/uploads/1769186731473-757421767.jpg", "phone": "123123323", "address": "Maraşel fevzi çakmak mahalessi 4098 sokak no 17D", "features": [{"icon": "Calendar", "text": "selamlar"}, {"icon": "Book", "text": "hocalara geldik"}], "isActive": true, "whatsapp": "12312", "description": "aasdsad", "customBanner": null, "primaryColor": "#ceff1f", "weekdayHours": "08:30 - 19:33", "weekendHours": "09:00 - 18:05", "successBanner": "/uploads/1769186737785-796155916.jpg"}	dde31d5c-b9ef-4f4f-b4f9-95192ec3ea8a	2026-01-26 06:32:10.558		2026-01-26 06:31:06.13	2026-01-26 06:32:10.559
8b9a16eb-595c-4e5a-a2bd-c0745a3d8c74	PACKAGE_CREATE	APPROVED	aa5d5dba-0088-4074-950f-2f0336190f8b	38aeca3e-8805-44e8-a87f-d87acabc0033	\N	Package	\N	{"name": "test", "slug": "test", "type": "VIP", "image": "/uploads/1769409260491-942423281.jpg", "isNew": false, "order": 0, "price": 123, "branchId": "38aeca3e-8805-44e8-a87f-d87acabc0033", "discount": null, "duration": "6", "features": null, "isActive": true, "isPopular": false, "videoCount": 100, "description": "selamlarselamlarselamlarselamlar", "subjectCount": 45, "originalPrice": 150, "shortDescription": "selamlar"}	dde31d5c-b9ef-4f4f-b4f9-95192ec3ea8a	2026-01-26 06:34:28.971		2026-01-26 06:34:20.901	2026-01-26 06:34:28.973
108fd2a2-8161-438f-a7eb-ad501a01ed85	PACKAGE_CREATE	APPROVED	aa5d5dba-0088-4074-950f-2f0336190f8b	38aeca3e-8805-44e8-a87f-d87acabc0033	\N	Package	\N	{"name": "selamlar", "slug": "selamlar", "type": "VIP", "image": "/uploads/1769409495650-16554277.jpg", "isNew": true, "order": 0, "price": 123, "branchId": "38aeca3e-8805-44e8-a87f-d87acabc0033", "discount": 23, "duration": "3", "features": ["asdada"], "isActive": true, "isPopular": true, "videoCount": 123, "description": "aasdada", "subjectCount": 123, "originalPrice": 1233, "shortDescription": "asdasd"}	dde31d5c-b9ef-4f4f-b4f9-95192ec3ea8a	2026-01-26 06:47:22.354		2026-01-26 06:38:18.153	2026-01-26 06:47:22.355
7ebdfc5e-9049-4a13-8684-f86138ea73d6	PACKAGE_CREATE	APPROVED	aa5d5dba-0088-4074-950f-2f0336190f8b	38aeca3e-8805-44e8-a87f-d87acabc0033	\N	Package	\N	{"name": "FSDFSF", "slug": "fsdfsf", "type": "VIP", "image": "/uploads/1769410344192-721385187.jpg", "isNew": true, "order": 0, "price": 123, "branchId": "38aeca3e-8805-44e8-a87f-d87acabc0033", "discount": 32, "duration": "123", "features": ["SDFSF", "SDF"], "isActive": true, "isPopular": true, "videoCount": 123, "description": "FSFSFS", "subjectCount": 123, "originalPrice": 123, "shortDescription": "SDFS"}	dde31d5c-b9ef-4f4f-b4f9-95192ec3ea8a	2026-01-26 06:52:32.941		2026-01-26 06:52:25.219	2026-01-26 06:52:32.942
d658b75e-e964-48a9-8bd9-11e34bf4f26e	BLOG_CREATE	APPROVED	aa5d5dba-0088-4074-950f-2f0336190f8b	38aeca3e-8805-44e8-a87f-d87acabc0033	\N	BlogPost	\N	{"date": "2026-01-26", "slug": "sfsfs", "image": "/uploads/1769412988131-355344823.jpg", "title": "sdfds", "author": "", "content": "fsfsfsdf", "excerpt": "fdsfs", "branchId": "38aeca3e-8805-44e8-a87f-d87acabc0033", "category": "Genel", "isActive": true, "readTime": "5 dk", "seoTitle": "sdfs", "isFeatured": true, "seoKeywords": "fdsfs", "seoDescription": "sdfs"}	dde31d5c-b9ef-4f4f-b4f9-95192ec3ea8a	2026-01-26 07:36:57.3		2026-01-26 07:36:42.292	2026-01-26 07:36:57.3
ef5fbbf4-6c09-4cd5-822e-e997a156c261	BLOG_CREATE	APPROVED	aa5d5dba-0088-4074-950f-2f0336190f8b	38aeca3e-8805-44e8-a87f-d87acabc0033	\N	BlogPost	\N	{"date": "2026-01-26", "slug": "sfdsfsfsfds", "image": "/uploads/1769413025065-473809428.jpg", "title": "dfssf", "author": "", "content": "sdfdsfsdfsdfsd", "excerpt": "fdsfdsf", "branchId": "38aeca3e-8805-44e8-a87f-d87acabc0033", "category": "Genel", "isActive": true, "readTime": "5 dk", "seoTitle": "sdfs", "isFeatured": true, "seoKeywords": "sdfdsfds", "seoDescription": "fdsfdsf"}	dde31d5c-b9ef-4f4f-b4f9-95192ec3ea8a	2026-01-26 07:38:30.122		2026-01-26 07:37:11.644	2026-01-26 07:38:30.123
1e448301-c66b-46e5-bf56-30788b9cbc39	PACKAGE_CREATE	APPROVED	aa5d5dba-0088-4074-950f-2f0336190f8b	38aeca3e-8805-44e8-a87f-d87acabc0033	\N	Package	\N	{"name": "sdfdsf", "slug": "sdfdsf", "type": "PREMIUM", "image": "/uploads/1769413455984-743372498.jpg", "isNew": true, "order": 0, "price": 123, "branchId": "38aeca3e-8805-44e8-a87f-d87acabc0033", "discount": 3112, "duration": "123", "features": ["sdfdsf"], "isActive": true, "isPopular": true, "videoCount": 123, "description": "fdsfdsf", "subjectCount": 12, "originalPrice": 12312, "shortDescription": "sdfs"}	dde31d5c-b9ef-4f4f-b4f9-95192ec3ea8a	2026-01-26 07:55:06.231		2026-01-26 07:44:16.952	2026-01-26 07:55:06.232
9e2d41f7-f979-4e7a-bab0-ea3b6e1c450d	SUCCESS_UPDATE	APPROVED	aa5d5dba-0088-4074-950f-2f0336190f8b	38aeca3e-8805-44e8-a87f-d87acabc0033	b1a9d3be-91f0-40d2-86c2-d46b625244fd	YearlySuccess	{"id": "b1a9d3be-91f0-40d2-86c2-d46b625244fd", "year": "2025", "banner": {"id": "11c74dfd-345c-4081-a1e4-e06dbb84ca3b", "image": "/uploads/1769415153123-689083399.jpg", "title": "ASDSA", "subtitle": "ASADAD", "gradientTo": "#1e40af", "description": "ASDASD", "gradientFrom": "#2563eb", "highlightText": null, "yearlySuccessId": "b1a9d3be-91f0-40d2-86c2-d46b625244fd"}, "branchId": "38aeca3e-8805-44e8-a87f-d87acabc0033", "isActive": true, "cityCount": 0, "createdAt": "2026-01-26T08:15:18.771Z", "updatedAt": "2026-01-26T08:15:18.771Z", "lgsAverage": 123, "yksAverage": 123, "successRate": 123, "top100Count": 123, "top1000Count": 123, "totalDegrees": 123, "placementCount": 123}	{"banner": {"image": "/uploads/1769415153123-689083399.jpg", "title": "ASDSA", "subtitle": "ASADAD", "description": ""}, "branchId": "38aeca3e-8805-44e8-a87f-d87acabc0033", "cityCount": 0, "lgsAverage": 123, "yksAverage": 123, "successRate": 123, "top100Count": 123, "top1000Count": 123, "totalDegrees": 123, "placementCount": 123}	dde31d5c-b9ef-4f4f-b4f9-95192ec3ea8a	2026-01-26 08:15:59.173		2026-01-26 08:15:54.834	2026-01-26 08:15:59.174
\.


--
-- Data for Name: ContactSubmission; Type: TABLE DATA; Schema: public; Owner: hocalara_admin
--

COPY public."ContactSubmission" (id, name, email, phone, subject, message, "branchId", "isRead", "isReplied", "createdAt", "updatedAt") FROM stdin;
59517002-a5bb-403e-bef1-a1c055b50c2e	sdfs	yigitselcuk2910@gmail.com	123123	sikayet	dsfdfs	\N	f	f	2026-01-22 17:23:10.981	2026-01-22 17:23:10.981
de7d85b7-fd74-468d-bacd-cc14b24ae2c9	dfgdg	admin@ecegen.com	123	bilgi	sdfs	\N	f	f	2026-01-22 17:23:46.635	2026-01-22 17:23:46.635
\.


--
-- Data for Name: EducationPackage; Type: TABLE DATA; Schema: public; Owner: hocalara_admin
--

COPY public."EducationPackage" (id, name, slug, type, description, "shortDescription", price, "originalPrice", image, features, "videoCount", "subjectCount", duration, "isPopular", "isNew", discount, "isActive", "order", "createdAt", "updatedAt", "branchId") FROM stdin;
7c3284af-b7d7-4d97-a7b6-f2e3a9d837bd	asdsad	asdsad	VIP	dasdsadascvbcbcvb	asdaghjhgjg	123	\N	/uploads/1769196860710-605311159.jpeg	null	123	123	3	f	f	\N	t	1	2026-01-23 19:25:09.356	2026-01-26 06:51:33.767	38aeca3e-8805-44e8-a87f-d87acabc0033
1dbd3e96-343b-4c9d-a888-f77684567776	sdf	sdf	sdfdsf	sdfdsfs	sdf	123	123	/uploads/1769092620247-777178766.jpeg	["sdfsfs", "sdfsdfs", "sdfs"]	123	123	12	t	t	\N	t	2	2026-01-22 14:37:09.491	2026-01-26 06:51:33.767	\N
17b53270-5779-49b0-a629-f778b9883e6b	tyt	tyt	STANDARD	asdasd	asdasd	1231	2343242	/uploads/1769067938765-248225554.jpeg	null	123	\N	\N	f	f	\N	t	3	2026-01-22 07:36:37.376	2026-01-26 06:51:33.767	\N
9f3b11c2-2a34-490b-acf8-531875712c2c	selamlar	selamlar	VIP	aasdada	asdasd	123	1233	/uploads/1769409495650-16554277.jpg	["asdada"]	123	123	3	t	t	23	t	4	2026-01-26 06:47:22.35	2026-01-26 06:51:33.767	38aeca3e-8805-44e8-a87f-d87acabc0033
7f0a1100-792b-449f-8d09-eed0f98f89a4	sdfdsf	sdfdsf	PREMIUM	fdsfdsf	sdfs	123	12312	/uploads/1769413455984-743372498.jpg	["sdfdsf"]	123	12	123	t	t	3112	t	0	2026-01-26 07:55:06.213	2026-01-26 07:55:06.213	38aeca3e-8805-44e8-a87f-d87acabc0033
\.


--
-- Data for Name: ExamDate; Type: TABLE DATA; Schema: public; Owner: hocalara_admin
--

COPY public."ExamDate" (id, "examName", "examDate", description, "order", "isActive", "createdAt", "updatedAt") FROM stdin;
49c49c2e-f6ff-49a8-8923-12fda1279c8b	AYT	2026-06-22 07:00:00		0	t	2026-01-21 20:12:48.284	2026-01-21 20:12:48.284
7f7995b1-52f1-4f32-969a-941154707f07	TYT	2026-06-21 07:00:00		0	t	2026-01-21 20:12:58.27	2026-01-21 20:12:58.27
8a7e2a41-7adf-4237-a71d-3bc6a42af245	TYT	2026-06-21 07:00:00		0	t	2026-01-21 20:13:28.701	2026-01-21 20:13:28.701
75fe2a0f-27d5-4408-8646-b02d204f2907	TYT	2026-06-21 07:00:00		0	t	2026-01-21 20:16:30.814	2026-01-21 20:16:30.814
63600190-be74-4fb0-a825-6d3a5b04d85c	TYT	2026-01-21 20:16:00		0	t	2026-01-21 20:16:39.457	2026-01-21 20:16:39.457
65564652-dd6c-48b0-8bcd-9920dfd8fa77	AYT	2026-01-22 20:16:00		0	t	2026-01-21 20:16:43.386	2026-01-21 20:16:43.386
ca32e0c0-0d9a-4e6e-9def-94714315dd98	AYT	2026-06-22 20:16:00		0	t	2026-01-21 20:16:50.87	2026-01-21 20:16:50.87
0edaecf9-ec91-42e3-b77d-b9f0633f75d5	TYT	2026-06-21 07:00:00		0	t	2026-01-21 20:18:42.744	2026-01-21 20:18:42.744
1bb3513a-9946-48c7-b49b-14d2c49745a6	TYT	2026-01-22 06:00:00		0	t	2026-01-22 05:18:06.854	2026-01-22 05:18:06.854
5aa9409c-6969-463b-9080-ff0acb1fcd73	TYT	2026-01-22 07:00:00		0	t	2026-01-22 05:18:11.954	2026-01-22 05:18:11.954
e0b0d362-23d3-4809-8930-025e4e8e61c8	AYT	2026-01-22 07:00:00		1	t	2026-01-22 05:18:16.822	2026-01-22 05:18:16.822
a7fc86e5-6d59-4a66-9bac-8e5d2a37e3d2	TYT	2026-06-21 06:00:00		0	t	2026-01-22 05:18:23.927	2026-01-22 05:18:23.927
9e4c8f1d-3dbe-4b65-900b-ecea950e812c	TYT	2026-06-21 07:00:00		0	t	2026-01-22 05:30:51.951	2026-01-22 05:30:51.951
5d1e6959-f317-4460-92ea-b06bc25bcf1f	TYT	2026-06-21 06:00:00		0	t	2026-01-22 05:31:04.521	2026-01-22 05:31:04.521
246d2dbf-4c7c-4886-9422-244518d965ae	TYT	2026-01-22 06:00:00		0	t	2026-01-22 06:36:32.576	2026-01-22 06:36:32.576
6423f275-835b-4eeb-932c-5b2d747f4f6b	TYT	2026-06-21 09:00:00		0	t	2026-01-22 06:40:10.132	2026-01-22 06:40:10.132
972d8c7f-d21e-4d24-9144-54d9f00ede8e	TYT	2026-05-21 09:00:00		0	t	2026-01-22 06:41:28.685	2026-01-22 06:41:28.685
5d3a8f6c-3f8a-444c-b55a-275e8d03ef58	TYT	2026-01-21 09:00:00		0	t	2026-01-22 06:43:45.626	2026-01-22 06:43:45.626
cdaed61b-b65b-4333-9d58-723ce0950ef6	TYT	2026-06-21 09:00:00		0	t	2026-01-22 06:43:57.615	2026-01-22 06:43:57.615
fbf6e5e6-eb38-4e8c-b1b8-6aeef42916c5	TYT	2026-01-21 09:00:00		0	t	2026-01-22 06:44:31.352	2026-01-22 06:44:31.352
aeba618d-2385-470a-b9c8-3603f73c07d3	TYT	2026-01-21 06:00:00		0	t	2026-01-22 06:36:37.972	2026-01-22 06:45:55.9
\.


--
-- Data for Name: Feature; Type: TABLE DATA; Schema: public; Owner: hocalara_admin
--

COPY public."Feature" (id, title, description, icon, section, features, "order", "isActive", "createdAt", "updatedAt") FROM stdin;
ac17d244-bb9b-4954-8b68-9acd161304fd	Merkezi Eğitim Sistemi ile Standart Kalite	Tüm şubelerimizde aynı kalitede eğitim	✅	centers	\N	1	t	2026-01-21 18:41:46.664	2026-01-21 18:41:46.664
df391808-4ec3-4412-8801-6436c3cea1f4	Her Şubede Uzman Öğretmen Kadrosu	Alanında uzman öğretmenler	✅	centers	\N	2	t	2026-01-21 18:41:46.669	2026-01-21 18:41:46.669
27a0ded3-8aab-4762-aba2-0957d0dc0e24	Modern Derslik ve Laboratuvar İmkanları	En son teknoloji ile donatılmış sınıflar	✅	centers	\N	3	t	2026-01-21 18:41:46.671	2026-01-21 18:41:46.671
43434eb3-94ce-4909-a6c2-d48811f384d3	Dijital Platform Entegrasyonu	Online ve offline eğitim bir arada	✅	centers	\N	4	t	2026-01-21 18:41:46.673	2026-01-21 18:41:46.673
87deb146-f469-47e0-b37d-dd607c26eb90	Veli Bilgilendirme ve Takip Sistemi	Öğrenci gelişimini anlık takip	✅	centers	\N	5	t	2026-01-21 18:41:46.675	2026-01-21 18:41:46.675
b63655a7-89b4-4ac7-86fa-b0dbf019c4f4	Öğrenci Paneli	Kişiye özel ders programı, performans takibi ve yapay zeka destekli analiz raporları	💻	digital	["Ders Programı", "Sınav Sonuçları", "İlerleme Grafikleri"]	1	t	2026-01-21 18:41:46.677	2026-01-21 18:41:46.677
c8417139-c7de-4565-b791-3a97df3a52c8	Veli Takip Sistemi	Çocuğunuzun akademik gelişimini anlık olarak takip edin ve raporlara erişin	👥	digital	["Devam Takibi", "Not Bildirimleri", "Öğretmen Görüşmeleri"]	2	t	2026-01-21 18:41:46.68	2026-01-21 18:41:46.68
66e9e3bc-0204-45eb-bbd5-6501e02ed080	Mobil Uygulama	iOS ve Android uygulamalarımızla her yerden eğitime erişim imkanı	📱	digital	["Canlı Dersler", "Video Arşivi", "Soru Çözüm"]	3	t	2026-01-21 18:41:46.682	2026-01-21 18:41:46.682
8e72fded-9e36-4a87-81fa-ca7cea873de6	Yurt Dışı Danışmanlık	Üniversite seçiminden vize sürecine kadar tüm aşamalarda profesyonel destek	🎯	global	["Üniversite Seçimi", "Başvuru Süreci", "Vize Danışmanlığı", "Burs İmkanları"]	1	t	2026-01-21 18:41:46.686	2026-01-21 18:41:46.686
67504530-086b-4ebf-871c-c1fb5330b99d	Dil Eğitimi	TOEFL, IELTS, SAT ve diğer uluslararası sınavlara hazırlık programları	📚	global	["TOEFL Hazırlık", "IELTS Kursu", "SAT Eğitimi", "Akademik İngilizce"]	2	t	2026-01-21 18:41:46.688	2026-01-21 18:41:46.688
a637f192-a892-41db-84a2-9edaca180cd3	Üniversite Yerleştirme	ABD, İngiltere, Kanada ve Avrupa üniversitelerine başarılı yerleştirme	🎓	global	["Profil Oluşturma", "Essay Desteği", "Mülakat Hazırlığı", "Takip Sistemi"]	3	t	2026-01-21 18:41:46.689	2026-01-21 18:41:46.689
327c56da-45f1-48c6-a35e-63ee70249052	Yapay Zeka Analiziewrewe	Öğrenme stilinize göre kişiselleştirilmiş içerik önerileri ve çalışma planıdsfs	🧠	digital	["Eksik Analizi", "Öneri Sistemi", "Hedef Belirlemesdfs"]	4	t	2026-01-21 18:41:46.684	2026-01-21 18:41:46.684
\.


--
-- Data for Name: FranchiseApplication; Type: TABLE DATA; Schema: public; Owner: hocalara_admin
--

COPY public."FranchiseApplication" (id, name, surname, phone, email, city, message, status, notes, "createdAt", "updatedAt") FROM stdin;
b14618a9-3fdb-4937-b6d5-fc127eeb7030	asdada	asdada	1231311	asdas@asdad	Adıyaman	asdad	NEW	\N	2026-01-24 20:05:19.967	2026-01-24 20:05:35.988
f0c14df3-b9fe-49a0-87a3-f9195b589ecb	sad	sad	123313	asdada@asda	Adıyaman	asdads	APPROVED	\N	2026-01-24 20:07:26.888	2026-01-24 20:07:37.458
\.


--
-- Data for Name: HomeSection; Type: TABLE DATA; Schema: public; Owner: hocalara_admin
--

COPY public."HomeSection" (id, title, subtitle, "order", "isActive", "createdAt", "updatedAt", "buttonLink", "buttonText", content, description, page, section, "seoDescription", "seoKeywords", "seoTitle") FROM stdin;
3170fc36-6955-4484-8e5d-21f31d6a39f4	Geleceğin Eğitimi Burada	Geleceğin Eğitim Vizyonu Burada	0	t	2026-01-21 15:38:16.766	2026-01-21 15:38:16.766	/subeler	Hemen Eğitime Başla	\N	\N	home	hero	\N	\N	\N
a22d10d4-44b2-45e8-83d3-32cc015a9d51	Hocalara Geldik	\N	0	t	2026-01-21 15:38:16.778	2026-01-21 15:38:16.778	\N	\N	\N	Türkiye'nin en büyük eğitim ağı ile öğrencilerimize en kaliteli eğitimi sunuyoruz.	home	about	\N	\N	\N
031cb709-56fd-4b08-9da5-0de3f002f1bc	Neden Hocalara Geldik?	Modern eğitim anlayışı ve teknoloji ile donatılmış altyapımızla fark yaratıyoruz	0	t	2026-01-21 15:38:16.78	2026-01-21 15:38:16.78	\N	\N	\N	\N	home	features	\N	\N	\N
806cb169-bb84-4674-b6f6-d09879ed77b1	Başarı Hikayelerimiz	\N	0	t	2026-01-21 15:38:16.782	2026-01-21 15:38:16.782	\N	\N	\N	Her yıl binlerce öğrencimiz hayallerine ulaşıyor	home	success	\N	\N	\N
614c3f4d-1e0a-40aa-ab08-94ee254020db	Şubelerimiz	81 İlde Güçlü Şube Ağı	0	t	2026-01-21 15:38:16.783	2026-01-21 15:38:16.783	\N	\N	\N	\N	home	branches	\N	\N	\N
a946bc88-6635-45f2-b506-9c24baafd79d	Eğitim Paketlerimiz	\N	0	t	2026-01-21 15:38:16.784	2026-01-21 15:38:16.784	\N	\N	\N	İhtiyacınıza uygun eğitim paketi ile akademik hedeflerinize ulaşın	home	packages	\N	\N	\N
a8c2430b-647c-4468-9b3d-37f9ab932ffc	Öğretmen Kadromuz	Alanında uzman, deneyimli öğretmenlerimizle başarıya ulaşın	0	t	2026-01-21 15:38:16.785	2026-01-21 15:38:16.785	\N	\N	\N	\N	home	teachers	\N	\N	\N
05a444b2-efa0-4970-a532-6b399d1900ae	Video Kütüphanemiz	\N	0	t	2026-01-21 15:38:16.787	2026-01-21 15:38:16.787	\N	\N	\N	Binlerce ücretsiz eğitim videosu ile her zaman yanınızdayız	home	videos	\N	\N	\N
a2e6af04-83ee-4afa-8797-85f28cc35546	Blog & Rehberlik	Akademik ve psikolojik destek yazıları, sınav stratejileri ve motivasyon içerikleri	0	t	2026-01-21 15:38:16.788	2026-01-21 15:38:16.788	\N	\N	\N	\N	home	blog	\N	\N	\N
f52db649-f31b-4493-aec4-604a909c1ff1	Bizimle İletişime Geçin	\N	0	t	2026-01-21 15:38:16.789	2026-01-21 15:38:16.789	\N	İletişim Formu	\N	Sorularınız için bize ulaşın, size en kısa sürede dönüş yapalım	home	contact	\N	\N	\N
26d19ac8-4f9a-4e9b-bfb0-8f1fbc110ac4	Türkiye'nin En Büyük Eğitim Ağı	81 ilde güçlü şube ağımız, modern eğitim altyapımız ve uzman kadromuzla öğrencilerimize en kaliteli eğitimi sunuyoruz	0	t	2026-01-21 15:38:16.791	2026-01-21 15:38:16.791	\N	\N	\N	\N	home	centers	\N	\N	\N
bdff8844-0a32-4808-aa79-b6d1aa83f646	Yapay Zeka Destekli Eğitim Platformu	Öğrenciler ve veliler için geliştirdiğimiz dijital altyapı ile eğitim sürecini her adımda takip edin ve kişiselleştirilmiş öğrenme deneyimi yaşayın	0	t	2026-01-21 15:38:16.792	2026-01-21 15:38:16.792	\N	\N	\N	\N	home	digital	\N	\N	\N
be351267-a448-4015-b220-235ccebc39f7	Geleceği El Birliğiyle İnşa Edelim	\N	0	t	2026-01-21 15:38:16.793	2026-01-21 15:38:16.793	/iletisim	Hemen Başvur	\N	Akademik Hedeflerinize Ulaşmanız İçin Uzman Kadromuz, Modern Eğitim Materyallerimiz Ve Dijital Çözümlerimizle Yanınızdayız	home	cta	\N	\N	\N
5a4978d5-0945-4892-abd4-12a7dbf29550	Eğitim Paketlerimiz	Size özel eğitim çözümleri	0	t	2026-01-21 15:38:16.812	2026-01-21 15:38:16.812	\N	\N	\N	\N	packages	hero	\N	\N	\N
02edfef5-8e38-4ed0-bcc1-52b45c8bdb2a	İhtiyacınıza Uygun Paket	\N	0	t	2026-01-21 15:38:16.813	2026-01-21 15:38:16.813	\N	\N	\N	Farklı ihtiyaçlara yönelik özel olarak tasarlanmış eğitim paketlerimiz	packages	intro	\N	\N	\N
5eb1c9a4-9a70-4ab3-b94e-499e21f4b428	Paketleri İnceleyin	\N	0	t	2026-01-21 15:38:16.814	2026-01-21 15:38:16.814	/paketler	Tüm Paketler	\N	\N	packages	cta	\N	\N	\N
89415bf8-5b69-426c-b8e2-5170653b8734	Video Kütüphanesi	Binlerce ücretsiz eğitim videosu	0	t	2026-01-21 15:38:16.815	2026-01-21 15:38:16.815	\N	\N	\N	\N	videos	hero	\N	\N	\N
52fc09e2-d308-4c2d-86a7-b658e81a193d	Her Zaman Yanınızda	\N	0	t	2026-01-21 15:38:16.816	2026-01-21 15:38:16.816	\N	\N	\N	Tüm dersler için kapsamlı video arşivimizle istediğiniz zaman çalışın	videos	intro	\N	\N	\N
c4c5a094-0770-4585-a96c-e82fcb52d43e	Video Kategorileri	Tüm dersler ve konular için videolar	0	t	2026-01-21 15:38:16.817	2026-01-21 15:38:16.817	\N	\N	\N	\N	videos	categories	\N	\N	\N
60425ace-0678-44e1-a053-58b279950b1a	Yurtdışı Eğitim Danışmanlığı	Dünya üniversitelerine açılan kapınız	0	t	2026-01-21 15:38:16.823	2026-01-21 15:38:16.823	\N	\N	\N	\N	international	hero	\N	\N	\N
52b0a34b-71f9-4f16-ac43-c5717b93f35b	Hayalinizdeki Üniversite	\N	0	t	2026-01-21 15:38:16.825	2026-01-21 15:38:16.825	\N	\N	\N	ABD, İngiltere, Kanada ve Avrupa üniversitelerine başarılı yerleştirme	international	intro	\N	\N	\N
0f124527-b627-48cd-b783-84880d9b77c6	Başarının Anahtarı: Kaliteli Eğitim	\N	0	t	2026-01-21 15:38:16.806	2026-01-21 15:38:16.806	\N	\N	\N	Her biri alanında uzman, deneyimli ve öğrenci odaklı öğretmenlerimizle başarıya ulaşın	teachers	intro	\N	\N	\N
a7cd22fe-d799-4a98-829a-7ee2b99ef8a6	Misyonumuz	\N	0	t	2026-01-21 15:38:16.796	2026-01-21 15:38:16.796	\N	\N	\N	Öğrencilerimize en kaliteli eğitimi sunarak geleceğin liderlerini yetiştirmek	about	mission	\N	\N	\N
c2bee6a0-a4ed-4713-8fa7-baea197c26ac	Vizyonumuz	\N	0	t	2026-01-21 15:38:16.797	2026-01-21 15:38:16.797	\N	\N	\N	Türkiye'nin en güvenilir ve tercih edilen eğitim kurumu olmak	about	vision	\N	\N	\N
aa73ca26-f668-437f-a52c-c2f78ec5aaa9	Hemen Kayıt Olun	\N	0	t	2026-01-21 15:38:16.803	2026-01-21 15:38:16.803	/subeler	Şube Bul	\N	\N	branches	cta	\N	\N	\N
85955f22-b86a-428e-b5b2-f54d846bc6ee	Tarihçemiz	\N	0	t	2026-01-21 15:38:16.799	2026-01-21 15:38:16.799	\N	\N	Yılların deneyimi ve binlerce başarı hikayesi ile eğitimde öncü kurum	\N	about	history	\N	\N	\N
c3edfe71-b9de-4248-8308-a6e557540338	Şubelerimiz	81 İlde Güçlü Şube Ağı	0	t	2026-01-21 15:38:16.801	2026-01-21 15:38:16.801	\N	\N	\N	\N	branches	hero	\N	\N	\N
752728b2-f130-430c-a556-92406e7b8f9d	Size En Yakın Şubeyi Bulun	\N	0	t	2026-01-21 15:38:16.802	2026-01-21 15:38:16.802	\N	\N	\N	Türkiye'nin her yerinde modern eğitim merkezlerimizle hizmetinizdeyiz	branches	intro	\N	\N	\N
30416669-1eb6-46ee-bc99-fd29d80b7bfe	Başarı Hikayelerimicxccz	Gurur Tablomuzfdgd	0	t	2026-01-21 15:38:16.809	2026-01-21 15:38:16.809	\N	\N	\N	\N	success	hero	\N	\N	\N
79fbd1b3-1117-4629-8bcf-fb5f1988a38d	Her Yıl Binlerce Öğrenci	\N	0	t	2026-01-21 15:38:16.81	2026-01-21 15:38:16.81	\N	\N	\N	Öğrencilerimiz hayallerindeki üniversitelere yerleşiyor	success	intro	\N	\N	\N
d7e75e04-5da3-496e-b556-5957e3ff11ef	Platform Özellikleri	\N	0	t	2026-01-21 15:38:16.82	2026-01-21 15:38:16.82	\N	\N	\N	Kişiselleştirilmiş öğrenme, canlı dersler, soru çözümü ve daha fazlası	digital	features	\N	\N	\N
fce0107c-31d6-483f-badc-651899631c88	Sıradaki Başarı Hikayesi Senin Olsun	\N	0	t	2026-01-21 15:38:16.811	2026-01-21 15:38:16.811	/iletisim	Hemen Başla	\N	\N	success	cta	\N	\N	\N
57fc29c4-a554-4f5d-b0b6-cf6e60d3d55e	Avantajlar	\N	0	t	2026-01-21 15:38:16.821	2026-01-21 15:38:16.821	\N	\N	\N	Her yerden erişim, performans takibi, yapay zeka analizi	digital	benefits	\N	\N	\N
c44b22ce-f1a1-452d-8f82-e2f9fab5a63f	Hemen Başlayın	\N	0	t	2026-01-21 15:38:16.822	2026-01-21 15:38:16.822	/kayit	Ücretsiz Dene	\N	\N	digital	cta	\N	\N	\N
d79b38aa-1179-445b-b98b-3fe9bbe9cfba	Değerlerimiz	\N	0	t	2026-01-21 15:38:16.798	2026-01-21 15:38:16.798	\N	\N	\N	Kalite, güven, yenilikçilik ve öğrenci odaklılık	about	values	\N	\N	\N
7de09e20-c565-4372-ad5f-416742f6fe18	Öğretmen Kadromuz	Alanında uzman, deneyimli eğitmenler	0	t	2026-01-21 15:38:16.805	2026-01-21 15:38:16.805	\N	\N	\N	\N	teachers	hero	\N	\N	\N
854c8cf5-f7dc-43b6-8857-707e0805704d	Kalite Standartlarımız	\N	0	t	2026-01-21 15:38:16.807	2026-01-21 15:38:16.807	\N	\N	\N	Tüm öğretmenlerimiz düzenli eğitim ve gelişim programlarından geçer	teachers	quality	\N	\N	\N
a2e10261-f85b-4cbd-8e3d-f8e38120889f	Hizmetlerimiz	\N	0	t	2026-01-21 15:38:16.826	2026-01-21 15:38:16.826	\N	\N	\N	Üniversite seçimi, başvuru süreci, vize danışmanlığı ve daha fazlası	international	services	\N	\N	\N
73d215a4-433f-44f1-b81c-a4f244339ba9	Danışmanlık Alın	\N	0	t	2026-01-21 15:38:16.828	2026-01-21 15:38:16.828	/iletisim	Randevu Oluştur	\N	\N	international	cta	\N	\N	\N
fe5dc9a8-49b7-4e02-8168-bdb5bbb013e0	Rehberlik Hizmetleri	Akademik ve psikolojik destek	0	t	2026-01-21 15:38:16.84	2026-01-21 15:38:16.84	\N	\N	\N	\N	guidance	hero	\N	\N	\N
16fe7ff8-142e-4847-8fd4-bfd6dc9ecd8f	Uzman Rehberlik	\N	0	t	2026-01-21 15:38:16.841	2026-01-21 15:38:16.841	\N	\N	\N	Öğrencilerimize akademik ve psikolojik destek sağlıyoruz	guidance	intro	\N	\N	\N
7e44fac2-7e11-499b-8971-5b8513f2a4d6	Hizmetlerimiz	\N	0	t	2026-01-21 15:38:16.842	2026-01-21 15:38:16.842	\N	\N	\N	Meslek seçimi, üniversite tercihi, sınav kaygısı ve motivasyon	guidance	services	\N	\N	\N
7e50a1e6-9f9e-4b98-bbd8-ca1758186aca	Hesaplama Araçları	Puan ve sıralama hesaplayıcıları	0	t	2026-01-21 15:38:16.844	2026-01-21 15:38:16.844	\N	\N	\N	\N	calculator	hero	\N	\N	\N
937a4759-5532-402f-bbed-f1a3d8069cf4	Hedeflerinizi Belirleyin	\N	0	t	2026-01-21 15:38:16.845	2026-01-21 15:38:16.845	\N	\N	\N	TYT, AYT, LGS puan hesaplama ve sıralama tahmin araçları	calculator	intro	\N	\N	\N
15c64354-2178-4da6-9834-89ec8bd70c9d	\N	Geleceğin Eğitim Vizyonu Burada	1	t	2026-01-21 17:19:42.704	2026-01-21 17:19:42.704	\N	\N	\N	\N	home	hero-subtitle	\N	\N	\N
9d975415-8fcb-49d4-9a26-52848a7a85a0	\N	\N	2	t	2026-01-21 17:19:42.711	2026-01-21 17:19:42.711	/iletisim	Hemen Eğitime Başla	\N	\N	home	hero-button-primary	\N	\N	\N
fcab494d-34e7-4a6d-a394-e35b048f062e	\N	\N	3	t	2026-01-21 17:19:42.713	2026-01-21 17:19:42.713	/franchise	Yeni Şubemiz Olun	\N	\N	home	hero-button-secondary	\N	\N	\N
9711c452-9206-4080-bdd5-ff7b35a1cd8e	Franchise Başvuru	\N	4	t	2026-01-21 17:19:42.715	2026-01-21 17:19:42.715	\N	\N	\N	Hocalara Geldik Ailesine Katılın	home	banner-card-1	\N	\N	\N
aab9dbac-37c5-4263-9b52-77fb0d51cb37	Kayıt Başvurusu	\N	5	t	2026-01-21 17:19:42.716	2026-01-21 17:19:42.716	\N	\N	\N	Eğitiminize Hemen Başlayın	home	banner-card-2	\N	\N	\N
8e24854c-e5c5-43ad-860b-a272aac84a7b	Başarı Merkezleri	\N	6	t	2026-01-21 17:19:42.717	2026-01-21 17:19:42.717	\N	\N	\N	81 İlde Güçlü Şube Ağı	home	banner-card-3	\N	\N	\N
dc45b54a-ff05-4ce3-a3d8-793b0013a61b	Dijital Platform	\N	7	t	2026-01-21 17:19:42.718	2026-01-21 17:19:42.718	\N	\N	\N	Yapay Zeka Destekli Eğitim	home	banner-card-4	\N	\N	\N
12512f52-b355-460b-b607-0168df646b70	YouTube	Geleceğin Eğitim Platformu	8	t	2026-01-21 17:19:42.719	2026-01-21 17:19:42.719	\N	\N	\N	Binlerce Ücretsiz İçerik	home	banner-card-5	\N	\N	\N
0fa6e299-96b2-4f97-9c63-128d46edcd43	Merkezi Eğitim Sistemi ile Standart Kalite	\N	13	t	2026-01-21 17:19:42.725	2026-01-21 17:19:42.725	\N	\N	\N	\N	home	centers-feature-1	\N	\N	\N
95974d1b-8040-43ae-85a0-f72a56116358	Her Şubede Uzman Öğretmen Kadrosu	\N	14	t	2026-01-21 17:19:42.726	2026-01-21 17:19:42.726	\N	\N	\N	\N	home	centers-feature-2	\N	\N	\N
31ae797f-4a29-413d-a871-c7fe1b7e7156	Modern Derslik ve Laboratuvar İmkanları	\N	15	t	2026-01-21 17:19:42.726	2026-01-21 17:19:42.726	\N	\N	\N	\N	home	centers-feature-3	\N	\N	\N
fab24a11-51ec-4c92-abe0-bf6d1b994d80	Dijital Platform Entegrasyonu	\N	16	t	2026-01-21 17:19:42.727	2026-01-21 17:19:42.727	\N	\N	\N	\N	home	centers-feature-4	\N	\N	\N
fc10b834-8575-4afe-98c5-ab52de2947f6	Veli Bilgilendirme ve Takip Sistemi	\N	17	t	2026-01-21 17:19:42.728	2026-01-21 17:19:42.728	\N	\N	\N	\N	home	centers-feature-5	\N	\N	\N
bb2e81b2-e19a-4921-aaa9-fe087781ba57	DİJİTAL EĞİTİM SİSTEMİ	\N	18	t	2026-01-21 17:19:42.729	2026-01-21 17:19:42.729	\N	\N	\N	\N	home	digital-top-title	\N	\N	\N
c254a01d-0ce1-4c92-a938-069dbb252fa3	Yapay Zeka Destekli Eğitim Platformu	\N	19	t	2026-01-21 17:19:42.73	2026-01-21 17:19:42.73	\N	\N	\N	\N	home	digital-title	\N	\N	\N
247e0c7d-1b8a-4037-b29a-1bd9dca923fd	\N	Öğrenciler ve veliler için geliştirdiğimiz dijital altyapı ile eğitim sürecini her adımda takip edin ve kişiselleştirilmiş öğrenme deneyimi yaşayın.	20	t	2026-01-21 17:19:42.73	2026-01-21 17:19:42.73	\N	\N	\N	\N	home	digital-subtitle	\N	\N	\N
1445a1eb-0aa1-4d33-81a6-9016d064b6ac	DİJİTAL İÇERİKLERİMİZ	\N	23	t	2026-01-21 17:19:42.733	2026-01-21 17:19:42.733	\N	\N	\N	\N	home	youtube-top-title	\N	\N	\N
baf30ecb-b7f6-49f7-8d03-0bec297b0449	YouTube Kanallarımız ve Sosyal Medya	\N	24	t	2026-01-21 17:19:42.734	2026-01-21 17:19:42.734	\N	\N	\N	\N	home	youtube-title	\N	\N	\N
5b0edbec-016d-43a3-9b05-6f3fee34519e	\N	Binlerce ücretsiz ders videosu ve güncel içeriklerimiz için kanallarımıza abone olun, sosyal medyada bizi takip edin!	25	t	2026-01-21 17:19:42.734	2026-01-21 17:19:42.734	\N	\N	\N	\N	home	youtube-subtitle	\N	\N	\N
38d5174e-ce25-4662-8203-ccdc687861e0	Sosyal Medyada Bizi Takip Edin	\N	26	t	2026-01-21 17:19:42.735	2026-01-21 17:19:42.735	\N	\N	\N	\N	home	youtube-social-title	\N	\N	\N
3de40881-2efa-45b7-ae2e-86ecffb51787	\N	Güncel duyurular, motivasyon içerikleri ve daha fazlası için sosyal medya hesaplarımızı takip edin!	27	t	2026-01-21 17:19:42.736	2026-01-21 17:19:42.736	\N	\N	\N	\N	home	youtube-social-subtitle	\N	\N	\N
de827a0f-ec45-4c18-8bfb-d1ad8a556712	Türkiye'nin En Büyük Eğitim Ağı	\N	10	t	2026-01-21 17:19:42.722	2026-01-21 19:12:23.678	\N	\N	\N	\N	home	centers-title	\N	\N	\N
426f7e4e-b309-45ff-a018-97e10a765558	\N	81 ilde güçlü şube ağımız, modern eğitim altyapımız ve uzman kadromuzla öğrencilerimize en kaliteli eğitimi sunuyoruz.	11	t	2026-01-21 17:19:42.723	2026-01-21 19:12:23.686	\N	\N	\N	\N	home	centers-subtitle	\N	\N	\N
55eaeb55-553c-4d4b-b35a-6d5455e6d783	\N	\N	12	t	2026-01-21 17:19:42.724	2026-01-21 19:12:23.694	/subeler	Şubelerimizi Keşfedinddfgd	\N	\N	home	centers-button	\N	\N	\N
d67f96de-36be-463c-98d5-7fc804efd467	Hocalara Geldik Yurt Dışı	\N	21	t	2026-01-21 17:19:42.732	2026-01-21 19:46:31.546	\N	\N	\N	\N	home	global-title	\N	\N	\N
8f82fd39-4995-46fc-8ce3-419a3b713cc7	\N	Dünya'nın en prestijli üniversitelerine yerleşme hayalinizi gerçeğe dönüştürüyoruzssa	22	t	2026-01-21 17:19:42.732	2026-01-21 19:46:31.575	\N	\N	\N	\N	home	global-subtitle	\N	\N	\N
dce08e81-fbdd-4d78-aa91-feae55fd1cee	İletişim	Bize ulaşın, size yardımcı olalım	0	t	2026-01-21 15:38:16.835	2026-01-21 15:38:16.835	\N	\N	\N	\N	contact	hero	\N	\N	\N
2f1930dc-43c6-4781-99d4-371dfe40ce18	cffHaberlerddd	Güncel eğitim haberleri ve duyurular	0	t	2026-01-21 15:38:16.847	2026-01-21 15:38:16.847	\N	\N	\N	\N	news	hero	\N	\N	\N
daae87cd-f334-4b5d-9afc-2ab7e7c5b644	Gereksinimler	\N	0	t	2026-01-21 15:38:16.833	2026-01-21 15:38:16.833	\N	\N	\N	Franchise olmak için gerekli şartlar ve yatırım bilgileri	franchise	requirements	\N	\N	\N
d6d1139c-b4f8-4228-a09d-da65847d3599	Hemen Başvurun	\N	0	t	2026-01-21 15:38:16.834	2026-01-21 15:38:16.834	/franchise	Franchise Başvurusu	\N	\N	franchise	cta	\N	\N	\N
812bbbc8-a307-4d5b-9975-b6443d4b4302	Franchise Fırsatı	Hocalara Geldik ailesine katılın	0	t	2026-01-21 15:38:16.829	2026-01-21 15:38:16.829	/franchise	Başvuru Yap	\N	\N	franchise	hero	\N	\N	\N
1a62ca9e-3bbd-4f6f-87c8-44edcc3118bd	Son Haberler	\N	0	t	2026-01-21 15:38:16.848	2026-01-21 15:38:16.848	\N	\N	\N	Eğitim dünyasından güncel haberler ve kurumumuzdan duyurular	news	intro	\N	\N	\N
b3d93632-b1d4-449a-b49a-2c9a9c510e64	Başarılı Bir İş Modeli	\N	0	t	2026-01-21 15:38:16.83	2026-01-21 15:38:16.83	\N	\N	\N	Türkiye'nin en büyük eğitim ağının bir parçası olun	franchise	intro	\N	\N	\N
cdcedfa0-74ce-40b7-ba3e-d70478ffe260	Sorularınız İçin	\N	0	t	2026-01-21 15:38:16.836	2026-01-21 15:38:16.836	\N	\N	\N	Size en kısa sürede dönüş yapalım	contact	intro	\N	\N	\N
bf8859e1-1de1-452d-9f04-667005adeb00	İletişim Formu	\N	0	t	2026-01-21 15:38:16.838	2026-01-21 15:38:16.838	\N	Gönder	\N	\N	contact	form	\N	\N	\N
b2de0888-ea88-42a6-b4c2-672caba2f6ac	REHBERLİK VE İÇERİKLER	\N	28	t	2026-01-21 17:19:42.736	2026-01-21 17:19:42.736	\N	\N	\N	\N	home	blog-top-title	\N	\N	\N
f543b51c-1a87-48fe-b270-84b9e2429737	Rehberlik ve Blog Notları	\N	29	t	2026-01-21 17:19:42.737	2026-01-21 17:19:42.737	\N	\N	\N	\N	home	blog-title	\N	\N	\N
b4a4bbdd-d4ef-4140-98ac-fc223c739a65	\N	Akademik ve psikolojik destek yazıları, sınav stratejileri ve motivasyon içerikleri ile başarıya giden yolda yanınızdayız.	30	t	2026-01-21 17:19:42.738	2026-01-21 17:19:42.738	\N	\N	\N	\N	home	blog-subtitle	\N	\N	\N
0d080d0a-c0a4-43d4-a995-2c2345b5e60f	Puan Hesaplama Araçları	\N	31	t	2026-01-21 17:19:42.739	2026-01-21 17:19:42.739	\N	\N	\N	\N	home	calculator-badge	\N	\N	\N
618cbdd2-04a7-41b3-93b8-212f20e18c66	Sınav Puanınızı Hesaplayın	\N	32	t	2026-01-21 17:19:42.739	2026-01-21 17:19:42.739	\N	\N	\N	\N	home	calculator-title	\N	\N	\N
3463623b-d9a8-49a4-af3d-3327079e5178	\N	Net sayılarınızı girerek yaklaşık sınav puanınızı hesaplayabilir ve hedeflerinize ne kadar yakın olduğunuzu görebilirsiniz.	33	t	2026-01-21 17:19:42.74	2026-01-21 17:19:42.74	\N	\N	\N	\N	home	calculator-subtitle	\N	\N	\N
f7244d20-3eda-4dde-9810-e5188a345489	\N	\N	34	t	2026-01-21 17:19:42.741	2026-01-21 17:19:42.741	/hesaplama	Hesaplama Araçlarına Git	\N	\N	home	calculator-button	\N	\N	\N
ea90588b-8234-401a-a767-03b542f0611d	ÇALIŞMA ARAÇLARI	\N	35	t	2026-01-21 17:19:42.741	2026-01-21 17:19:42.741	\N	\N	\N	\N	home	tools-top-title	\N	\N	\N
5e4a8c03-19af-4f26-848c-6d6bebcfc6c5	Sınav Geri Sayımı ve Pomodoro	\N	36	t	2026-01-21 17:19:42.742	2026-01-21 17:19:42.742	\N	\N	\N	\N	home	tools-title	\N	\N	\N
f2eb5fb5-05ef-4b32-84ae-e473d1c600ad	\N	Sınavınıza kalan süreyi takip edin ve Pomodoro tekniği ile verimli çalışma seansları oluşturun.	37	t	2026-01-21 17:19:42.743	2026-01-21 17:19:42.743	\N	\N	\N	\N	home	tools-subtitle	\N	\N	\N
21a02df6-ceac-486e-bd98-0ba390856fde	Sınava Kalan Süre	\N	38	t	2026-01-21 17:19:42.743	2026-01-21 17:19:42.743	\N	\N	\N	\N	home	tools-countdown-title	\N	\N	\N
e4841d3d-1208-44fb-bb00-8fc3ce712b94	Pomodoro Zamanlayıcı	\N	39	t	2026-01-21 17:19:42.744	2026-01-21 17:19:42.744	\N	\N	\N	\N	home	tools-pomodoro-title	\N	\N	\N
86c24cfc-edca-4a9d-94cc-796591473d05	EĞİTİM PAKETLERİMİZ	\N	40	t	2026-01-21 17:19:42.745	2026-01-21 17:19:42.745	\N	\N	\N	\N	home	packages-top-title	\N	\N	\N
63a56301-5d8f-44a8-908b-de7b5c8ed67e	Size Uygun Paketi Seçin	\N	41	t	2026-01-21 17:19:42.745	2026-01-21 17:19:42.745	\N	\N	\N	\N	home	packages-title	\N	\N	\N
9075b137-ffaf-42c7-97b4-ebcd6f23b256	\N	İhtiyacınıza uygun eğitim paketi ile akademik hedeflerinize ulaşın.	42	t	2026-01-21 17:19:42.746	2026-01-21 17:19:42.746	\N	\N	\N	\N	home	packages-subtitle	\N	\N	\N
de6ab55c-da05-4848-906f-ad678a8a68bf	\N	\N	43	t	2026-01-21 17:19:42.746	2026-01-21 17:19:42.746	/paketler	Tüm Paketleri İncele	\N	\N	home	packages-button	\N	\N	\N
fa5eb0ae-a84b-4849-983b-088a187b8dcc	\N	\N	47	t	2026-01-21 17:19:42.748	2026-01-21 17:19:42.748	\N	\N	\N	Akademik Hedeflerinize Ulaşmanız İçin Uzman Kadromuz, Modern Eğitim Materyallerimiz Ve Dijital Çözümlerimizle Yanınızdayız.	home	cta-description	\N	\N	\N
2dae8da5-bbce-46c2-8d51-5b0352bcd9de	BAŞARI MERKEZLERİMİZ	\N	9	t	2026-01-21 17:19:42.72	2026-01-21 19:12:23.661	\N	\N	\N	\N	home	centers-top-title	\N	\N	\N
27ae137a-3e18-41ca-bc25-2334c1ae9586	\N	\N	50	t	2026-01-21 17:19:42.749	2026-01-22 10:36:25.624	\N	\N	\N	81 Şehirde Binlerce Öğrenci Geleceğine Güvenle Hazırlanıyor.	home	cta-testimonial	\N	\N	\N
40cc3cf3-269c-4ba8-843a-738f130d9073	\N	\N	0	t	2026-01-22 10:36:25.63	2026-01-22 10:36:25.63	/uploads/1769078185569-986785922.jpeg	\N	\N	\N	home	cta-image	\N	\N	\N
3752ecc1-3830-4084-b375-861b6eef5d15	Akademi Ana Sayfası	\N	0	t	2026-01-22 11:42:05.351	2026-01-22 11:42:05.351	/	\N	\N	\N	home	footer-menu-column1-item-1769082125350-0	\N	\N	\N
7ef813be-27a3-4f26-ac31-096f879f0392	Tüm Akademik Şubelerimiz	\N	1	t	2026-01-22 11:42:05.353	2026-01-22 11:42:05.353	/subeler	\N	\N	\N	home	footer-menu-column1-item-1769082125352-1	\N	\N	\N
dca40533-8475-4278-a612-b0faa64b1ed3	\N	\N	0	t	2026-01-22 11:42:05.365	2026-01-22 17:45:27.057	/assets/images/logoblue.svg	\N	\N	\N	home	footer-logo	\N	\N	\N
4c8df7d8-50c5-493a-8b13-ea00787bf265	Geleceği El Birliğiyle İnşa Edeldddim.	\N	46	t	2026-01-21 17:19:42.748	2026-01-22 10:36:25.587	\N	\N	\N	\N	home	cta-main-title	\N	\N	\N
175ccb12-d190-4b5a-a542-a13c8f0c4014	\N	Akademik Hedeflerinize Ulaşmanız İçin Uzman Kadromuz, Modern Eğitim Materyallerimiz Ve Dijital Çözümlerimizle Yanınızdayız.	0	t	2026-01-22 07:55:52.345	2026-01-22 10:36:25.595	\N	\N	\N	\N	home	cta-subtitle	\N	\N	\N
225380bb-b588-449d-8606-d7e8bf6b59d5	\N	\N	48	t	2026-01-21 17:19:42.749	2026-01-22 10:36:25.602	/subeler	Hemen Kayıt Bffaşvurusu	\N	\N	home	cta-button-primary	\N	\N	\N
5b3f7675-00dc-47b9-8e0a-dc9685d2b64e	\N	\N	49	t	2026-01-21 17:19:42.749	2026-01-22 10:36:25.608	/franchise	Akademik Şubemiz Olun	\N	\N	home	cta-button-secondary	\N	\N	\N
a1fbfe15-37c5-4e4a-92d0-c3b9f8d012ce	Sıradaki Başarı Öyküsü...	\N	44	t	2026-01-21 17:19:42.747	2026-01-22 10:36:25.613	\N	\N	\N	\N	home	cta-badge	\N	\N	\N
0969d76c-f168-4de9-bc76-97f7568478f3	Neden Sizin Başagrı Hikdayeniz Olmasın?	\N	45	t	2026-01-21 17:19:42.747	2026-01-22 10:36:25.618	\N	\N	\N	\N	home	cta-question	\N	\N	\N
7807bd45-b14d-492a-9d3d-1747e41e7d13	\N	\N	0	t	2026-01-22 07:55:52.355	2026-01-22 07:56:38.924	/iletisim	Hemen Kayıt Başvfghurusuff	\N	\N	home	cta-button1	\N	\N	\N
77702a75-97ac-4f05-a221-6186c5a82d4d	\N	\N	0	t	2026-01-22 07:55:52.361	2026-01-22 07:56:38.928	/franchise	Akademik Şubemiz Olun	\N	\N	home	cta-button2	\N	\N	\N
ce7772e9-5c9a-45ff-8f12-138a349d8555	Haftalık Deneme Sınavları	\N	4	t	2026-01-22 11:42:05.361	2026-01-22 11:42:05.361	#	\N	\N	\N	home	footer-menu-column2-item-1769082125360-4	\N	\N	\N
07037e69-fa4f-4ef2-9fc1-f457290b1992	Güncel Haberler Ve Duyurular	\N	2	t	2026-01-22 11:42:05.356	2026-01-22 11:42:05.356	/haberler	\N	\N	\N	home	footer-menu-column1-item-1769082125356-4	\N	\N	\N
7b4677cc-2e2c-426f-b758-5b04b88f9ea1	Hızlı Menü Linkleri	\N	0	t	2026-01-22 11:42:05.343	2026-01-22 17:45:27.046	\N	\N	\N	\N	home	footer-menu-column1	\N	\N	\N
2f989744-6bd4-4d47-8a52-139397f64d6d	Eğitim Programları	\N	0	t	2026-01-22 11:42:05.347	2026-01-22 17:45:27.047	\N	\N	\N	\N	home	footer-menu-column2	\N	\N	\N
e56cf75a-62ab-4bb0-a6b5-396d89b55c1a	Genel İletişim Hattı	\N	0	t	2026-01-22 11:42:05.349	2026-01-22 17:45:27.048	\N	\N	\N	\N	home	footer-menu-column3	\N	\N	\N
8ae8e36b-d89f-451b-866c-104fa0d7be7b	Hocalara Geldik Akademi Grubu. Tüm hakları saklıdır.	\N	0	t	2026-01-22 11:42:05.363	2026-01-22 17:45:27.056	\N	\N	\N	\N	home	footer-copyright	\N	\N	\N
c7ac15d9-1f41-4e2d-9a28-e90edad488ef	Güncel Haberler Ve Duyurular	\N	4	t	2026-01-22 11:44:33.709	2026-01-22 11:44:33.709	/haberler	\N	\N	\N	home	footer-menu-column1-item-1769082273708-4	\N	\N	\N
025f91a1-94a1-4c05-966f-c1b1a5683176	Üniversite Hazırlık (YKS)	\N	0	t	2026-01-22 11:44:33.71	2026-01-22 11:44:33.71	#	\N	\N	\N	home	footer-menu-column2-item-1769082273709-0	\N	\N	\N
a3f2df2f-9397-4976-9583-48ed45af7f04	Hakkımızda	\N	0	t	2026-01-22 11:44:33.714	2026-01-22 11:44:33.714	/hakkimizda	\N	\N	\N	home	footer-menu-column3-item-1769082273714-0	\N	\N	\N
e5e0685e-8d5b-4cd0-b7ad-6608a75f9ea0	İletişim	\N	1	t	2026-01-22 11:44:33.715	2026-01-22 11:44:33.715	/iletisim	\N	\N	\N	home	footer-menu-column3-item-1769082273714-1	\N	\N	\N
943909cc-db56-4d5f-b87b-5fb22eaf2510	Gizlilik Sözleşmesi	\N	2	t	2026-01-22 11:44:33.715	2026-01-22 11:44:33.715	/gizlilik	\N	\N	\N	home	footer-menu-column3-item-1769082273715-2	\N	\N	\N
aaa4eba1-498e-40dd-ae84-50f45177e20a	Öğrenci Gurur Tablomuz	\N	2	t	2026-01-22 11:46:38.924	2026-01-22 11:46:38.924	/basarilarimiz	\N	\N	\N	home	footer-menu-column1-item-1769082398924-2	\N	\N	\N
92a43769-1d5e-433c-b7c3-0c9b4cb89daf	Franchise Başvuru Formu	\N	3	t	2026-01-22 11:46:38.925	2026-01-22 11:46:38.925	/franchise	\N	\N	\N	home	footer-menu-column1-item-1769082398925-3	\N	\N	\N
5b82cbac-0cd2-4401-97cc-1eacd5e5888a	Lise Giriş Sınavı (LGS)	\N	1	t	2026-01-22 11:46:38.928	2026-01-22 11:46:38.928	#	\N	\N	\N	home	footer-menu-column2-item-1769082398928-1	\N	\N	\N
18500021-3775-4779-a36b-54a739ef3db4	Dijital Soru Çözüm Arşivi	\N	2	t	2026-01-22 11:46:38.93	2026-01-22 11:46:38.93	#	\N	\N	\N	home	footer-menu-column2-item-1769082398930-2	\N	\N	\N
ab4dd680-980a-467f-9540-4be7f304f4b6	Uzman Rehberlik Hizmetleri	\N	3	t	2026-01-22 11:46:38.931	2026-01-22 11:46:38.931	#	\N	\N	\N	home	footer-menu-column2-item-1769082398930-3	\N	\N	\N
0d8f90b9-c7b6-4212-84da-6dd00061834c	Kullanım Şartları	\N	3	t	2026-01-22 11:46:38.935	2026-01-22 11:46:38.935	/kullanim-sartlari	\N	\N	\N	home	footer-menu-column3-item-1769082398934-3	\N	\N	\N
0fdf4be3-d888-48d0-a9b0-ca5476ebc17f	KVKK Aydınlatma Metni	\N	4	t	2026-01-22 11:46:38.936	2026-01-22 11:46:38.936	/kvkk	\N	\N	\N	home	footer-menu-column3-item-1769082398936-4	\N	\N	\N
b385332f-ebd7-417d-9e36-daaa2a14e3e3	KVKK Aydınlatma Metni	\N	2	t	2026-01-22 11:46:38.944	2026-01-22 11:46:38.944	/kvkk	\N	\N	\N	home	footer-bottom-link-1769082398943-2	\N	\N	\N
a59e73f4-ed64-4b61-bf74-b0beed277630	İletişim	\N	2	t	2026-01-22 12:23:18.319	2026-01-22 12:23:18.319	/iletisim	\N	\N	\N	home	header-topbar-link-1769084598318-2	\N	\N	\N
c446e278-d56b-46da-83d8-7a826acdce01	Gizlilik Sözleşmesi	\N	0	t	2026-01-22 11:46:38.942	2026-01-22 11:46:38.942	/gizlilik	\N	\N	\N	home	footer-bottom-link-1769082398942-0	\N	\N	\N
60903bd5-5e5f-42b0-beb5-9206f16d6d0a	Kullanım Şartları	\N	1	t	2026-01-22 11:46:38.943	2026-01-22 11:46:38.943	/kullanim-sartlari	\N	\N	\N	home	footer-bottom-link-1769082398943-1	\N	\N	\N
4391afad-d723-4b9a-85a7-6abb646c7a74	\N	\N	0	t	2026-01-22 12:23:18.314	2026-01-22 17:45:27.059	/assets/images/logoblue.svg	\N	\N	\N	home	header-logo	\N	\N	\N
a513e8cc-c9b4-45dd-8558-5a48a33c7aa2	Şubeler	\N	0	t	2026-01-22 12:23:18.318	2026-01-22 12:23:18.318	/subeler	\N	\N	\N	home	header-topbar-link-1769084598317-1	\N	\N	\N
efbf6409-c322-43bf-a739-990835e92cb3	Hakkımızda	\N	1	t	2026-01-22 12:23:18.316	2026-01-22 12:23:18.316	/hakkimizda	\N	\N	\N	home	header-topbar-link-1769084598316-0	\N	\N	\N
238c4f3f-8ca5-4cce-9c13-746fa36a5e75	Kurumsalff	\N	0	t	2026-01-22 12:36:37.499	2026-01-22 12:36:37.499	\N	\N	\N	\N	about	about-hero-badge	\N	\N	\N
d13781bd-eb23-4791-8976-b0f92ef0c080	0212 000 00 00	\N	0	t	2026-01-22 12:23:18.315	2026-01-22 17:45:27.059	\N	\N	\N	\N	home	header-phone	\N	\N	\N
26fd8aee-e60c-4ba5-8b4f-b4ef08232d8e	Toplumsal sorumluluk bilinci	\N	0	t	2026-01-22 12:36:37.513	2026-01-22 12:36:37.513	\N	\N	\N	\N	about	about-mission-item4	\N	\N	\N
6c43acc1-6484-48d7-ac94-0fd7b078d5fc	Ana Sayfa	\N	0	t	2026-01-22 12:26:01.055	2026-01-22 12:26:01.055	/	\N	\N	\N	home	header-menu-link-1769084761054-0	\N	\N	\N
a48eae3c-2e83-4ed9-a75b-3ac75ae96939	Videolar	\N	1	t	2026-01-22 12:26:01.057	2026-01-22 12:26:01.057	/videolar	\N	\N	\N	home	header-menu-link-1769084761056-1	\N	\N	\N
824e486b-9d1f-4f52-b1bf-6e2ae3048c2b	Başarılar	\N	4	t	2026-01-22 12:26:01.059	2026-01-22 12:26:01.059	/basarilarimiz	\N	\N	\N	home	header-menu-link-1769084761059-4	\N	\N	\N
92169feb-37c8-4871-a3f4-379be97b5bfd	Haberler	\N	5	t	2026-01-22 12:26:01.06	2026-01-22 12:26:01.06	/haberler	\N	\N	\N	home	header-menu-link-1769084761059-5	\N	\N	\N
b98ebcbf-39ab-414f-a152-a3ff17db6ef7	Franchise	\N	6	t	2026-01-22 12:26:01.061	2026-01-22 12:26:01.061	/franchise	\N	\N	\N	home	header-menu-link-1769084761060-6	\N	\N	\N
2fcd2357-4e58-4437-8fd7-5b540e7da6b2	Şubeler	\N	2	t	2026-01-22 12:26:01.058	2026-01-22 12:26:01.058	/subeler	\N	\N	\N	home	header-menu-link-1769084761058-3	\N	\N	\N
05c43a56-81c9-4d76-9ca6-125709f92c67	Paketler	\N	3	t	2026-01-22 12:26:01.058	2026-01-22 12:26:01.058	/paketler	\N	\N	\N	home	header-menu-link-1769084761057-2	\N	\N	\N
f7873b0f-d3e9-4819-bbf2-329bae25563f	\N	Türkiye'nin öncü eğitim markası olarak, binlerce öğrencinin hayallerine ulaşmasına yardımcı oluyoruz.	0	t	2026-01-22 12:36:37.505	2026-01-22 12:36:37.505	\N	\N	\N	\N	about	about-hero-subtitle	\N	\N	\N
ee27f041-fa39-4672-949c-800b67eb32b1	Kaliteli ve erişilebilir eğitim	\N	0	t	2026-01-22 12:36:37.51	2026-01-22 12:36:37.51	\N	\N	\N	\N	about	about-mission-item1	\N	\N	\N
9a8e2251-3dde-44bc-b64a-7d65aa230c17	Vizyonumuz	\N	0	t	2026-01-22 12:36:37.515	2026-01-22 12:36:37.515	\N	\N	\N	\N	about	about-vision-title	\N	\N	\N
bbd8691c-68e4-45a7-bce4-24f8cfe70372	Sürekli gelişim ve yenilik	\N	0	t	2026-01-22 12:36:37.512	2026-01-22 12:36:37.512	\N	\N	\N	\N	about	about-mission-item3	\N	\N	\N
87ace048-1f43-4bf2-98e3-ccc116437bba	\N	\N	0	t	2026-01-22 12:36:37.508	2026-01-22 12:36:37.508	\N	\N	\N	Öğrencilerimize en kaliteli eğitimi sunarak, akademik hedeflerine ulaşmalarını sağlamak ve geleceğin lider bireylerini yetiştirmek.	about	about-mission-description	\N	\N	\N
34acd88c-5db8-4a59-8f38-5d407d0b37e0	Öğrenci odaklı yaklaşım	\N	0	t	2026-01-22 12:36:37.511	2026-01-22 12:36:37.511	\N	\N	\N	\N	about	about-mission-item2	\N	\N	\N
c51f0193-0bd1-400a-817d-e57a5413e4e6	Misyonumuz	\N	0	t	2026-01-22 12:36:37.507	2026-01-22 12:36:37.507	\N	\N	\N	\N	about	about-mission-title	\N	\N	\N
0e6709a6-fd0e-4054-88a7-b806c2d9b2a8	Hakkımızda	\N	0	t	2026-01-22 12:36:37.504	2026-01-22 12:36:37.504	\N	\N	\N	\N	about	about-hero-title	\N	\N	\N
94fa6fbc-75e7-48c1-83ef-3fea8b2bfe71	\N	\N	0	t	2026-01-22 12:36:37.516	2026-01-22 12:36:37.516	\N	\N	\N	Türkiye'nin en güvenilir ve tercih edilen eğitim kurumu olmak, dijital dönüşümde öncü rol oynamak ve uluslararası standartlarda eğitim hizmeti sunmak.	about	about-vision-description	\N	\N	\N
4fa328bb-8a6f-45d1-89a1-eb71cd71d74e	\N	\N	0	t	2026-01-22 11:42:05.362	2026-01-22 17:45:27.055	\N	\N	\N	Türkiye'nin Öncü Eğitim Markası Olarak, Akademik Başarınızı En Modern Teknolojiler Ve Uzman Kadromuzla Destekliyoruz.	home	footer-description	\N	\N	\N
02b40029-0ca2-4108-8590-b5e0055df88f	Kalite	\N	0	t	2026-01-22 12:36:37.525	2026-01-22 12:36:37.525	\N	\N	\N	\N	about	about-value2-title	\N	\N	\N
26dde650-85dd-418b-b66e-39a525b2458e	\N	Başarı Oranı	0	t	2026-01-22 12:36:37.536	2026-01-22 12:36:37.536	\N	\N	\N	\N	about	about-stat4-label	\N	\N	\N
c2bd1c1c-3554-416d-9805-b5544a1a21a8	Takım Çalışması	\N	0	t	2026-01-22 12:36:37.527	2026-01-22 12:36:37.527	\N	\N	\N	\N	about	about-value3-title	\N	\N	\N
a698ff50-dcf1-45d9-a087-5c2d19150172	Öğrenci Odaklılık	\N	0	t	2026-01-22 12:36:37.523	2026-01-22 12:36:37.523	\N	\N	\N	\N	about	about-value1-title	\N	\N	\N
3ef2fc18-a28f-440b-a144-600cfdfd7c5b	Sektörde liderlik	\N	0	t	2026-01-22 12:36:37.519	2026-01-22 12:36:37.519	\N	\N	\N	\N	about	about-vision-item3	\N	\N	\N
93754bba-540f-4570-85df-0b72b237bd02	\N	İlde Şube	0	t	2026-01-22 12:36:37.534	2026-01-22 12:36:37.534	\N	\N	\N	\N	about	about-stat2-label	\N	\N	\N
3e170c60-29d4-4822-b6df-8500d4e5e785	Sürdürülebilir başarı	\N	0	t	2026-01-22 12:36:37.52	2026-01-22 12:36:37.52	\N	\N	\N	\N	about	about-vision-item4	\N	\N	\N
eac11ab1-174d-4005-9188-bc89fdb3518d	Başarı Hikayenizin Parçası Olun	\N	0	t	2026-01-22 12:36:37.536	2026-01-22 12:36:37.536	\N	\N	\N	\N	about	about-cta-title	\N	\N	\N
48b4d27e-248d-43c9-ba16-948c891f194f	Uluslararası standartlar	\N	0	t	2026-01-22 12:36:37.518	2026-01-22 12:36:37.518	\N	\N	\N	\N	about	about-vision-item2	\N	\N	\N
0e27e442-abfd-45fc-b99a-8ed7b97095b3	\N	\N	0	t	2026-01-22 12:36:37.53	2026-01-22 12:36:37.53	\N	\N	\N	Kendimizi ve sistemlerimizi sürekli geliştiriyoruz	about	about-value4-desc	\N	\N	\N
c8e037b5-a7b3-4361-9248-e9628739068a	\N	Mezun Öğrenci	0	t	2026-01-22 12:36:37.535	2026-01-22 12:36:37.535	\N	\N	\N	\N	about	about-stat3-label	\N	\N	\N
cacdb20c-3c4c-41bf-898f-7f505c751f9d	Hakkımızda	Türkiye'nin en büyük eğitim ailesi	0	t	2026-01-21 15:38:16.795	2026-01-21 15:38:16.795	\N	\N	\N	\N	about	hero	\N	\N	\N
5e82bab1-7d0d-4583-ac55-c9f56575cfea	Sürekli Gelişim	\N	0	t	2026-01-22 12:36:37.529	2026-01-22 12:36:37.529	\N	\N	\N	\N	about	about-value4-title	\N	\N	\N
be13b422-a1e0-49ea-806e-56b401eaee5d	Değerlerimiz	\N	0	t	2026-01-22 12:36:37.521	2026-01-22 12:36:37.521	\N	\N	\N	\N	about	about-values-badge	\N	\N	\N
b2c879dc-515f-4cf8-a902-2f615991eedf	81	\N	0	t	2026-01-22 12:36:37.533	2026-01-22 12:36:37.533	\N	\N	\N	\N	about	about-stat2-value	\N	\N	\N
2667892f-e59a-43c3-8088-252fb29a9a18	Aradığınız kriterde şube bulunamadı.	\N	0	t	2026-01-22 13:09:52.297	2026-01-22 17:45:27.078	\N	\N	\N	\N	branches	branches-card-empty	\N	\N	\N
b7ecbf30-165d-40ce-863d-b9d322b48208	Yeni dönem kayıtları	\N	0	t	2026-01-22 13:09:52.294	2026-01-22 17:45:27.077	\N	\N	\N	\N	branches	branches-card-badge	\N	\N	\N
211b644d-6f3b-48e9-90fa-f7d25d20471c	Harita görünümü	\N	0	t	2026-01-22 13:09:52.293	2026-01-22 17:45:27.077	\N	\N	\N	\N	branches	branches-view-map	\N	\N	\N
c1d4bfd0-9712-4580-8e83-245a8c45e001	Harita Navigasyonu	\N	0	t	2026-01-22 13:09:52.3	2026-01-22 17:45:27.079	\N	\N	\N	\N	branches	branches-map-info-title	\N	\N	\N
ce07aa5b-18e7-4d36-92bf-ff141f8c8f4c	Temel Değerlerimiz	\N	0	t	2026-01-22 12:36:37.522	2026-01-22 12:36:37.522	\N	\N	\N	\N	about	about-values-title	\N	\N	\N
5a359b08-73e9-46da-bf79-c1047f5a445f	\N	Yıllık Deneyim	0	t	2026-01-22 12:36:37.532	2026-01-22 12:36:37.532	\N	\N	\N	\N	about	about-stat1-label	\N	\N	\N
e6763ff4-3d14-4f42-8a59-7a0600b19c29	\N	Binlerce öğrencinin tercih ettiği Hocalara Geldik ailesine katılın ve hayallerinize ulaşın.	0	t	2026-01-22 12:36:37.537	2026-01-22 12:36:37.537	\N	\N	\N	\N	about	about-cta-subtitle	\N	\N	\N
09d11289-56a6-470b-a538-e21174a8066f	\N	\N	0	t	2026-01-22 12:36:37.538	2026-01-22 12:36:37.538	/iletisim	Bize Ulaşınj	\N	\N	about	about-cta-button2	\N	\N	\N
dc54cdfd-941d-40f5-b57a-53dbc7a6464b	15+	\N	0	t	2026-01-22 12:36:37.531	2026-01-22 12:36:37.531	\N	\N	\N	\N	about	about-stat1-value	\N	\N	\N
b7efc849-42a3-41e6-a1d8-3aa19a76ad8f	Şube bul	\N	0	t	2026-01-22 13:09:52.29	2026-01-22 17:45:27.075	\N	\N	\N	\N	branches	branches-hero-search-label	\N	\N	\N
d24b1fc4-ca85-487f-b6fe-cb4d47f14353	Şubeyi incele	\N	0	t	2026-01-22 13:09:52.296	2026-01-22 17:45:27.078	\N	\N	\N	\N	branches	branches-card-button	\N	\N	\N
be8378fd-83e0-49da-a73c-2c6935546511	50K+	\N	0	t	2026-01-22 12:36:37.534	2026-01-22 12:36:37.534	\N	\N	\N	\N	about	about-stat3-value	\N	\N	\N
45563fa1-a577-42ec-a81f-5a55e8de3f71	%98	\N	0	t	2026-01-22 12:36:37.535	2026-01-22 12:36:37.535	\N	\N	\N	\N	about	about-stat4-value	\N	\N	\N
c5c915de-4d84-482c-98ee-f2523511b1d1	\N	\N	0	t	2026-01-22 12:36:37.524	2026-01-22 12:36:37.524	\N	\N	\N	Her öğrencimizin ihtiyaçlarına özel çözümler üretiyoruz	about	about-value1-desc	\N	\N	\N
b8de9eb7-e578-4392-91f4-324158d19a2c	Türkiye Şubelerimiz	\N	0	t	2026-01-22 13:09:52.284	2026-01-22 17:45:27.072	\N	\N	\N	\N	branches	branches-hero-title	\N	\N	\N
cea27ce1-312b-430c-848d-d8549dcb0fe7	Teknoloji destekli eğitim	\N	0	t	2026-01-22 12:36:37.517	2026-01-22 12:36:37.517	\N	\N	\N	\N	about	about-vision-item1	\N	\N	\N
1407aab8-cc6c-47bb-8b47-969e5b543309	\N	\N	0	t	2026-01-22 12:36:37.526	2026-01-22 12:36:37.526	\N	\N	\N	En yüksek eğitim standartlarını koruyoruz	about	about-value2-desc	\N	\N	\N
9b852b15-d1c4-4bb8-a066-05f639071b37	\N	\N	0	t	2026-01-22 12:36:37.528	2026-01-22 12:36:37.528	\N	\N	\N	Güçlü ekip ruhuyla hareket ediyoruz	about	about-value3-desc	\N	\N	\N
5bbd9943-5d9e-4c61-b8ad-5ee3125c5a18	\N	\N	0	t	2026-01-22 13:09:52.301	2026-01-22 17:45:27.079	\N	\N	\N	Şube pinlerine tıklayarak detaylı bilgilere ulaşabilir ve Google Maps'te açabilirsiniz.	branches	branches-map-info-desc	\N	\N	\N
7787c958-123e-4522-8f7d-e7967a79e9bd	Tüm listeyi gör	\N	0	t	2026-01-22 13:09:52.299	2026-01-22 17:45:27.079	\N	\N	\N	\N	branches	branches-card-empty-button	\N	\N	\N
6ca3d64a-00cc-4a9e-92c5-b123fdf2c283	\N	İl veya ilçe ara...	0	t	2026-01-22 13:09:52.291	2026-01-22 17:45:27.076	\N	\N	\N	\N	branches	branches-hero-search-placeholder	\N	\N	\N
2b02e89d-262f-4ac4-b013-0c8eac00863e	Liste görünümü	\N	0	t	2026-01-22 13:09:52.291	2026-01-22 17:45:27.076	\N	\N	\N	\N	branches	branches-view-list	\N	\N	\N
0e2a5a7a-4ea4-430f-b8dd-c17a88462794	\N	81 şubemiz ve binlerce öğrencimizle kocaman bir aileyiz. Size en yakın şubeyi bulup hemen başlayın.	0	t	2026-01-22 13:09:52.287	2026-01-22 17:45:27.073	\N	\N	\N	\N	branches	branches-hero-subtitle	\N	\N	\N
bc52bf9c-a632-4267-aa60-5b8830c7e13f	\N	\N	0	t	2026-01-22 12:36:37.537	2026-01-22 12:36:37.537	/subeler	Şubelerimizi Keşfedin	\N	\N	about	about-cta-button1	\N	\N	\N
8d6dbffa-dbe8-4290-8826-9997a6f8e2c6	YKS Başarıları	\N	4	t	2026-01-22 15:08:56.779	2026-01-22 17:45:27.127	\N	\N	\N	\N	success	success-filter-yks	\N	\N	\N
8caff728-7fc1-4dc1-875f-141507dc134e	Şube Detayları	\N	0	t	2026-01-22 13:09:52.303	2026-01-22 17:45:27.081	\N	\N	\N	\N	branches	branches-map-detail-button	\N	\N	\N
79155939-f949-4556-af1e-48b0e2bb0a3f	Toplam Şube	\N	0	t	2026-01-22 13:09:52.302	2026-01-22 17:45:27.08	\N	\N	\N	\N	branches	branches-map-total-label	\N	\N	\N
af78c0f1-bcd8-4a2e-9c34-54fe8fafd1c0	YKS 2027	\N	0	t	2026-01-22 13:21:07.024	2026-01-22 17:45:27.094	\N	\N	\N	\N	packages	packages-filter-yks2027	\N	\N	\N
551e79fe-ade0-45c7-b96e-0508bde4b575	9-10-11. Sınıf	\N	0	t	2026-01-22 13:21:07.025	2026-01-22 17:45:27.094	\N	\N	\N	\N	packages	packages-filter-9-10-11	\N	\N	\N
436c1593-b3f5-442e-868e-39506ca23396	KPSS	\N	0	t	2026-01-22 13:21:07.025	2026-01-22 17:45:27.095	\N	\N	\N	\N	packages	packages-filter-kpss	\N	\N	\N
2860b329-fc05-4b8a-adb6-65867510620e	DGS	\N	0	t	2026-01-22 13:21:07.026	2026-01-22 17:45:27.095	\N	\N	\N	\N	packages	packages-filter-dgs	\N	\N	\N
811a5555-c2ed-40fb-a1fc-32fd0509c7cb	Popüler	\N	0	t	2026-01-22 13:21:07.026	2026-01-22 17:45:27.096	\N	\N	\N	\N	packages	packages-card-popular	\N	\N	\N
0a14f978-1077-4619-83e6-58befa0dd0d7	Yeni	\N	0	t	2026-01-22 13:21:07.026	2026-01-22 17:45:27.096	\N	\N	\N	\N	packages	packages-card-new	\N	\N	\N
c826fb96-88d8-4f96-a82f-ea59cd5d51bf	İndirim	\N	0	t	2026-01-22 13:21:07.027	2026-01-22 17:45:27.097	\N	\N	\N	\N	packages	packages-card-discount	\N	\N	\N
7fbb84be-600e-4a1f-a0db-55efbd1c67f2	Video	\N	0	t	2026-01-22 13:21:07.027	2026-01-22 17:45:27.097	\N	\N	\N	\N	packages	packages-card-video-label	\N	\N	\N
90920929-5924-40b8-a38c-ab3c9597e4aa	Süre	\N	0	t	2026-01-22 13:21:07.028	2026-01-22 17:45:27.097	\N	\N	\N	\N	packages	packages-card-duration-label	\N	\N	\N
11705349-41f9-4220-97b2-62b77b2fc3f7	Eğitim Paketlerimiz	\N	0	t	2026-01-22 13:21:07.018	2026-01-22 17:45:27.089	\N	\N	\N	\N	packages	packages-hero-badge	\N	\N	\N
987a514a-eeb3-454f-9df2-8634733fb128	Başarıya Giden Yol	\N	0	t	2026-01-22 13:21:07.02	2026-01-22 17:45:27.091	\N	\N	\N	\N	packages	packages-hero-title	\N	\N	\N
448cd079-94d3-4893-af78-dfc17b3df9e5	\N	İhtiyacınıza uygun paketi seçin ve akademik hedeflerinize ulaşın.	0	t	2026-01-22 13:21:07.021	2026-01-22 17:45:27.091	\N	\N	\N	\N	packages	packages-hero-subtitle	\N	\N	\N
55dba7b1-3559-49e1-b353-87973e44c28e	Tüm Paketler	\N	0	t	2026-01-22 13:21:07.023	2026-01-22 17:45:27.092	\N	\N	\N	\N	packages	packages-filter-all	\N	\N	\N
0188d56b-dc65-4ffd-ab10-a01559dbd5f7	YKS 2026	\N	0	t	2026-01-22 13:21:07.023	2026-01-22 17:45:27.092	\N	\N	\N	\N	packages	packages-filter-yks2026	\N	\N	\N
d14904bb-8084-46c5-855c-c129931bba3d	LGS 2026	\N	0	t	2026-01-22 13:21:07.024	2026-01-22 17:45:27.093	\N	\N	\N	\N	packages	packages-filter-lgs2026	\N	\N	\N
f1984d91-4e96-4925-a160-1f91cbaeda1a	Ders	\N	0	t	2026-01-22 13:21:07.028	2026-01-22 17:45:27.098	\N	\N	\N	\N	packages	packages-card-subject-label	\N	\N	\N
38416fcb-94a0-486d-969e-89af33c20ea7	Paket İçeriği	\N	0	t	2026-01-22 13:21:07.028	2026-01-22 17:45:27.098	\N	\N	\N	\N	packages	packages-card-content-label	\N	\N	\N
ba970230-08a1-4711-9002-ffd04aa64152	özellik daha	\N	0	t	2026-01-22 13:21:07.029	2026-01-22 17:45:27.099	\N	\N	\N	\N	packages	packages-card-more-features	\N	\N	\N
026d8131-71f2-4ad2-bca7-05affa47f7b6	Detaylı İncele	\N	0	t	2026-01-22 13:21:07.029	2026-01-22 17:45:27.099	\N	\N	\N	\N	packages	packages-card-button	\N	\N	\N
7eef27c6-02c3-47ad-80b9-e15dd9503fcd	Bu kategoriye ait paket bulunamadı.	\N	0	t	2026-01-22 13:21:07.03	2026-01-22 17:45:27.099	\N	\N	\N	\N	packages	packages-empty-message	\N	\N	\N
9452ef0f-1205-45dc-966c-e68dffe85bf5	Paketler yükleniyor...	\N	0	t	2026-01-22 13:21:07.03	2026-01-22 17:45:27.1	\N	\N	\N	\N	packages	packages-loading-message	\N	\N	\N
0ba09d1c-0ccf-481e-82df-0b7531440e3f	Akademik Başarı Geçmişimiz	\N	0	t	2026-01-22 15:08:56.775	2026-01-22 17:45:27.123	\N	\N	\N	\N	success	success-hero-badge	\N	\N	\N
05b94645-f527-4a99-a817-93ed525aa21a	Gurur Tablomuz	\N	1	t	2026-01-22 15:08:56.777	2026-01-22 17:45:27.125	\N	\N	\N	\N	success	success-hero-title	\N	\N	\N
91953462-0a42-4696-841b-eb8303f9cd58	\N	Her yıl binlerce öğrencimiz hayallerine ulaşıyor. Yıllar içindeki başarı hikayelerimizi keşfedin.	2	t	2026-01-22 15:08:56.777	2026-01-22 17:45:27.125	\N	\N	\N	\N	success	success-hero-subtitle	\N	\N	\N
06e6d974-d095-4529-b93f-10cfaf97ab6e	Tüm Sınavlar	\N	3	t	2026-01-22 15:08:56.778	2026-01-22 17:45:27.126	\N	\N	\N	\N	success	success-filter-all	\N	\N	\N
9e2b10b1-d92b-4d38-b85c-94d7cfdde4e3	\N	Arama kriterlerinize uygun haber bulunmamaktadır.	9	t	2026-01-22 15:27:08.606	2026-01-22 17:45:27.145	\N	\N	\N	\N	news	news-empty-subtitle	\N	\N	\N
91876231-22ba-4ce7-b147-fb2c99a06bde	\N	\N	10	t	2026-01-22 15:57:20.971	2026-01-22 17:45:27.145	\N	Filtreleri Temizle	\N	\N	news	news-empty-button	\N	\N	\N
89bd682a-ca8d-4780-b2b1-2cc88a3f9ba7	Geleceğin Eğitim Yatırımı	\N	0	t	2026-01-22 16:47:15.901	2026-01-22 17:45:27.172	\N	\N	\N	\N	franchise	franchise-hero-badge	\N	\N	\N
ebda7956-d290-4387-8590-fa2e3e80c954	Şubemiz Olun	\N	1	t	2026-01-22 16:47:15.903	2026-01-22 17:45:27.174	\N	\N	\N	\N	franchise	franchise-hero-title	\N	\N	\N
2541d0e8-b85a-44d9-982f-a5a16d3c0b3e	\N	Hocalara Geldik ekosistemine katılarak Türkiye'nin en dinamik eğitim ağıyla başarıya ortak olun.	2	t	2026-01-22 16:47:15.904	2026-01-22 17:45:27.175	\N	\N	\N	\N	franchise	franchise-hero-subtitle	\N	\N	\N
d80aa440-ad18-4ed9-82c6-191fd244a5b2	\N	\N	3	t	2026-01-22 16:47:15.905	2026-01-22 17:45:27.176	#apply	Başvuru Yap	\N	\N	franchise	franchise-hero-button-primary	\N	\N	\N
4b0e608a-6021-4aec-bb99-9bc426df9287	\N	\N	4	t	2026-01-22 16:47:15.907	2026-01-22 17:45:27.176	#	Sunum Dosyası (PDF)	\N	\N	franchise	franchise-hero-button-secondary	\N	\N	\N
4242bad8-ecf4-4056-8603-0e4c5af02a66	HABERLER VE DUYURULARdfg	\N	0	t	2026-01-22 15:27:08.599	2026-01-22 17:45:27.138	\N	\N	\N	\N	news	news-hero-badge	\N	\N	\N
b748304f-642b-4948-b721-09ee03e9f693	Hocalara Geldik Dünyasından Haberler	\N	1	t	2026-01-22 15:27:08.601	2026-01-22 17:45:27.139	\N	\N	\N	\N	news	news-hero-title	\N	\N	\N
33b58bd7-f84b-4662-956e-1d319418193a	\N	Tüm şubelerimizden en güncel başarı hikayeleri, duyurular ve etkinliklerden haberdar olun.	2	t	2026-01-22 15:27:08.602	2026-01-22 17:45:27.14	\N	\N	\N	\N	news	news-hero-subtitle	\N	\N	\N
91869105-84d5-4fee-8d8f-44d4561ab690	Haberlerde ara...	\N	3	t	2026-01-22 15:57:20.967	2026-01-22 17:45:27.14	\N	\N	\N	\N	news	news-search-placeholder	\N	\N	\N
34c3cf41-a565-4873-aff3-e8798f13d256	Duyurular	\N	4	t	2026-01-22 15:27:08.603	2026-01-22 15:55:44.641	\N	\N	\N	\N	news	news-filter-announcements	\N	\N	\N
f2c711e7-aebd-45df-a28d-e35623205e42	Tüm Şubeler	\N	4	t	2026-01-22 15:27:08.603	2026-01-22 17:45:27.142	\N	\N	\N	\N	news	news-filter-all	\N	\N	\N
dfe77beb-fae1-40dc-a9d1-75ca8bb835ea	Genel Haber	\N	5	t	2026-01-22 15:57:20.969	2026-01-22 17:45:27.143	\N	\N	\N	\N	news	news-card-general	\N	\N	\N
88c94dff-94e5-4dec-9f1a-9782d72f7d45	Etkinlikler	\N	5	t	2026-01-22 15:27:08.604	2026-01-22 15:55:44.642	\N	\N	\N	\N	news	news-filter-events	\N	\N	\N
6dbbfc88-b6f4-41e5-8c9f-dd74ff368f99	Başarı Hikayeleri	\N	6	t	2026-01-22 15:27:08.604	2026-01-22 15:55:44.642	\N	\N	\N	\N	news	news-filter-success	\N	\N	\N
831b18d0-0b0b-4d7a-b31f-b95540d16cbc	Bugün	\N	6	t	2026-01-22 15:57:20.969	2026-01-22 17:45:27.144	\N	\N	\N	\N	news	news-card-today	\N	\N	\N
26b0b8d3-57cd-4efa-b48e-45826d22efb8	DETAYLI OKU	\N	7	t	2026-01-22 15:57:20.97	2026-01-22 17:45:27.144	\N	\N	\N	\N	news	news-card-read-more	\N	\N	\N
4d325839-72f1-457f-8c0c-a34abbee0258	LGS Başarıları	\N	5	t	2026-01-22 15:08:56.779	2026-01-22 17:45:27.127	\N	\N	\N	\N	success	success-filter-lgs	\N	\N	\N
ccfe7670-dc29-415a-ac86-f2559187e45d	Sıradaki Başarı Hikayesi Neden Sen Olmayasın?	\N	6	t	2026-01-22 15:08:56.78	2026-01-22 17:45:27.128	\N	\N	\N	\N	success	success-cta-title	\N	\N	\N
e1523012-147f-4c3e-9c5b-d3aeaf0d0eab	\N	Hemen sana en yakın şubemizi bul ve kaliteli eğitimle sınav hazırlığına başla.	7	t	2026-01-22 15:08:56.78	2026-01-22 17:45:27.128	\N	\N	\N	\N	success	success-cta-subtitle	\N	\N	\N
67e722e9-3cfe-4eed-9522-12ca8569536e	Hemen Başla	\N	8	t	2026-01-22 15:08:56.781	2026-01-22 17:45:27.128	/subeler	\N	\N	\N	success	success-cta-button	\N	\N	\N
f2fd4435-cb42-4394-beb8-6c3355307616	Haber Bulunamadı	\N	8	t	2026-01-22 15:27:08.605	2026-01-22 17:45:27.145	\N	\N	\N	\N	news	news-empty-title	\N	\N	\N
148a846b-dc3a-47d5-ab9c-7d850c3e5a46	Franchise Süreci Nasıl İşler?	\N	11	t	2026-01-22 16:47:15.912	2026-01-22 17:45:27.18	\N	\N	\N	\N	franchise	franchise-process-title	\N	\N	\N
3152790b-0dc7-423c-96d7-2b9337e6cad6	Başvuru & Ön Görüşme	\N	12	t	2026-01-22 16:47:15.913	2026-01-22 17:45:27.18	\N	\N	\N	\N	franchise	franchise-process-step1-title	\N	\N	\N
91eb1f30-184b-4792-aba3-c51439d9e1eb	\N	Aşağıdaki formu doldurarak ilk adımı atın, temsilcilerimiz sizi arasın.	13	t	2026-01-22 16:47:15.913	2026-01-22 17:45:27.181	\N	\N	\N	\N	franchise	franchise-process-step1-desc	\N	\N	\N
9255196b-fbfa-49ed-969d-ba552b876098	Bölge Analizi	\N	14	t	2026-01-22 16:47:15.914	2026-01-22 17:45:27.181	\N	\N	\N	\N	franchise	franchise-process-step2-title	\N	\N	\N
a87cc365-be65-47ed-a548-7ebc8728baf2	\N	Kurulması planlanan şube için pazar ve potansiyel analizi yapılır.	15	t	2026-01-22 16:47:15.914	2026-01-22 17:45:27.181	\N	\N	\N	\N	franchise	franchise-process-step2-desc	\N	\N	\N
9f2555d0-55e1-4370-93b1-b8af4b62ef83	Sözleşme & Kurulum	\N	16	t	2026-01-22 16:47:15.915	2026-01-22 17:45:27.182	\N	\N	\N	\N	franchise	franchise-process-step3-title	\N	\N	\N
058508c4-aa0b-4cfe-afc8-b2fe5ab30d06	\N	Karşılıklı onay sonrası kurumsal kimliğimize uygun şube kurulumu başlar.	17	t	2026-01-22 16:47:15.915	2026-01-22 17:45:27.183	\N	\N	\N	\N	franchise	franchise-process-step3-desc	\N	\N	\N
aa0cf5bd-e317-4800-b952-cbdb7f2f5b5e	Hızlı İletişim	\N	18	t	2026-01-22 16:47:15.916	2026-01-22 17:45:27.183	\N	\N	\N	\N	franchise	franchise-contact-title	\N	\N	\N
9ddfa122-a05a-4629-8ffd-c59111b5bd55	0212 555 00 00	\N	19	t	2026-01-22 16:47:15.917	2026-01-22 17:45:27.184	\N	\N	\N	\N	franchise	franchise-contact-phone	\N	\N	\N
3a6145ff-069b-4d56-8b17-47c0803a32cb	kurumsal@hocalarageldik.com	\N	20	t	2026-01-22 16:47:15.918	2026-01-22 17:45:27.184	\N	\N	\N	\N	franchise	franchise-contact-email	\N	\N	\N
73d4f546-c807-48f8-9a11-d604c6bb8d31	Ön Başvuru Formu	\N	21	t	2026-01-22 16:47:15.918	2026-01-22 17:45:27.184	\N	\N	\N	\N	franchise	franchise-form-title	\N	\N	\N
f540370a-265e-41ed-83e7-b838a269c097	\N	\N	22	t	2026-01-22 16:47:15.919	2026-01-22 17:45:27.185	\N	Başvuruyu Tamamla	\N	\N	franchise	franchise-form-button	\N	\N	\N
47b28bb8-a4b6-42e6-9bf2-57ff488d9541	Bize Ulaşın	\N	0	t	2026-01-22 17:16:02.066	2026-01-22 17:45:27.195	\N	\N	\N	\N	contact	contact-hero-badge	\N	\N	\N
8509071f-7beb-4fa0-b1db-f3ef984bec41	İletişim	\N	1	t	2026-01-22 17:16:02.067	2026-01-22 17:45:27.196	\N	\N	\N	\N	contact	contact-hero-title	\N	\N	\N
4a3a2824-6ac1-4977-b185-d59dc331c584	\N	Sorularınız için bize ulaşın. Size yardımcı olmaktan mutluluk duyarız.	2	t	2026-01-22 17:16:02.068	2026-01-22 17:45:27.197	\N	\N	\N	\N	contact	contact-hero-subtitle	\N	\N	\N
db95f3e2-0155-48e2-b2fa-0d174aa5306d	İletişim Bilgileri	\N	3	t	2026-01-22 17:16:02.069	2026-01-22 17:45:27.198	\N	\N	\N	\N	contact	contact-info-title	\N	\N	\N
878a1650-3f30-4989-b716-6975ae31846b	\N	Sorularınız, önerileriniz veya kayıt başvurunuz için bizimle iletişime geçebilirsiniz.	4	t	2026-01-22 17:16:02.07	2026-01-22 17:45:27.199	\N	\N	\N	\N	contact	contact-info-desc	\N	\N	\N
620bb7ec-6d16-4f26-9431-2bb6b0d82d3f	Adres	\N	5	t	2026-01-22 17:16:02.07	2026-01-22 17:45:27.199	\N	\N	\N	\N	contact	contact-address-title	\N	\N	\N
73f19f75-f363-4eb4-ac13-47337cf218b1	Güçlü İçerik Altyapısı	\N	5	t	2026-01-22 16:47:15.908	2026-01-22 17:45:27.177	\N	\N	\N	\N	franchise	franchise-why-card1-title	\N	\N	\N
749eb627-f237-4d04-a040-cfcdb9f497f3	\N	Binlerce video ders, PDF yayınlar ve deneme sınavlarıyla içerik derdiniz olmasın.	6	t	2026-01-22 16:47:15.909	2026-01-22 17:45:27.177	\N	\N	\N	\N	franchise	franchise-why-card1-desc	\N	\N	\N
c7a85d01-db6e-46e7-8bfd-565ed746535d	Dijital Yönetim	\N	7	t	2026-01-22 16:47:15.91	2026-01-22 17:45:27.178	\N	\N	\N	\N	franchise	franchise-why-card2-title	\N	\N	\N
338844d3-93de-4c62-ab80-d4a5557a14ab	\N	Öğrenci takip, devamsızlık ve sınav analiz yazılımlarımızla şubenizi kolayca yönetin.	8	t	2026-01-22 16:47:15.91	2026-01-22 17:45:27.178	\N	\N	\N	\N	franchise	franchise-why-card2-desc	\N	\N	\N
29d93c82-6faf-485f-a246-ebbdfcc32e38	Bölge Güvencesi	\N	9	t	2026-01-22 16:47:15.911	2026-01-22 17:45:27.179	\N	\N	\N	\N	franchise	franchise-why-card3-title	\N	\N	\N
bf914de2-dcd7-499a-8e05-e8d907593632	\N	Haksız rekabeti önlemek adına bölgenizde tek şube olma garantisi sağlıyoruz.	10	t	2026-01-22 16:47:15.911	2026-01-22 17:45:27.179	\N	\N	\N	\N	franchise	franchise-why-card3-desc	\N	\N	\N
9c7f2b5e-aa37-4d54-9672-49ed06d69185	\N	Verdiğiniz bilgiler KVKK kapsamında güvence altındadır.	23	t	2026-01-22 16:47:15.92	2026-01-22 17:45:27.186	\N	\N	\N	\N	franchise	franchise-form-privacy	\N	\N	\N
db49ff9d-eabc-464b-98fc-66a697efaf50	Franchise Avantajları	\N	0	t	2026-01-21 15:38:16.831	2026-01-21 15:38:16.831	\N	\N	\N	Güçlü marka, merkezi destek, eğitim programları ve pazarlama desteği	franchise	benefits	\N	\N	\N
97407dae-1408-43eb-9a4e-85029dfc6f48	Bize Mesaj Gönderin	\N	20	t	2026-01-22 17:16:02.077	2026-01-22 17:45:27.206	\N	\N	\N	\N	contact	contact-form-title	\N	\N	\N
b8c10422-5ea8-4b30-a231-d28606cf354a	\N	\N	21	t	2026-01-22 17:16:02.077	2026-01-22 17:45:27.206	\N	Mesajı Gönder	\N	\N	contact	contact-form-button	\N	\N	\N
86f1b08f-8e71-4fa3-a275-610ecdce62d1	Video Kütüphanesi		1	t	2026-01-22 17:36:22.124	2026-01-22 17:45:27.215	\N		\N	\N	video-library	video-hero-badge	\N	\N	\N
94dc9778-fa10-4d0c-895c-95d57662d338	5000+ Saat		2	t	2026-01-22 17:36:22.125	2026-01-22 17:45:27.217	\N		\N	\N	video-library	video-hero-title	\N	\N	\N
77284d1d-0da9-463a-ae24-fedd5329cc0b	Ders İçeriği		3	t	2026-01-22 17:36:22.126	2026-01-22 17:45:27.218	\N		\N	\N	video-library	video-hero-title-highlight	\N	\N	\N
200733c6-1884-4857-b249-e5fecd9be65b	Rakamlarla Video Kütüphanemiz		5	t	2026-01-22 17:36:22.127	2026-01-22 17:45:27.218	\N		\N	\N	video-library	video-stats-badge	\N	\N	\N
2174094e-3b37-48bc-bb67-9f11247937ea	Sınırsız		6	t	2026-01-22 17:36:22.128	2026-01-22 17:45:27.219	\N		\N	\N	video-library	video-stats-title	\N	\N	\N
33093b9f-6636-4f8c-82f1-6ced5731bf60	Eğitim İçeriği		7	t	2026-01-22 17:36:22.129	2026-01-22 17:45:27.219	\N		\N	\N	video-library	video-stats-title-highlight	\N	\N	\N
18344db1-b1a9-4e0f-8af0-601cfd6cefac	5000+		8	t	2026-01-22 17:36:22.129	2026-01-22 17:45:27.22	\N		\N	\N	video-library	video-stat1-value	\N	\N	\N
3fde9e07-0609-4d4b-8ed8-95cb868d0b05	Saat Video		9	t	2026-01-22 17:36:22.129	2026-01-22 17:45:27.22	\N		\N	\N	video-library	video-stat1-label	\N	\N	\N
431fae39-dc39-40df-94a4-fc15ddb2dca3	15K+		10	t	2026-01-22 17:36:22.13	2026-01-22 17:45:27.221	\N		\N	\N	video-library	video-stat2-value	\N	\N	\N
85755bc9-c2dd-4415-98fc-12ffd45d60fa	\N	0212 000 00 00	10	t	2026-01-22 17:16:02.072	2026-01-22 17:45:27.201	\N	\N	\N	\N	contact	contact-phone-line1	\N	\N	\N
51719833-f3b9-466e-9f1c-30517797a311	\N	0850 000 00 00	11	t	2026-01-22 17:16:02.073	2026-01-22 17:45:27.202	\N	\N	\N	\N	contact	contact-phone-line2	\N	\N	\N
3dc62d93-e9c4-417c-beaa-83712c2a28ed	E-posta	\N	12	t	2026-01-22 17:16:02.073	2026-01-22 17:45:27.202	\N	\N	\N	\N	contact	contact-email-title	\N	\N	\N
952a6be8-372b-4225-bc3f-1e826d00d8b3	\N	bilgi@hocalarageldik.com	13	t	2026-01-22 17:16:02.074	2026-01-22 17:45:27.203	\N	\N	\N	\N	contact	contact-email-line1	\N	\N	\N
9e1f5275-4f1a-4377-9091-667b37bd1c6e		Tüm derslere ait binlerce video ders, konu anlatımı ve soru çözümü ile sınırsız erişim. İstediğiniz zaman, istediğiniz yerden öğrenin.	4	t	2026-01-22 17:36:22.127	2026-01-22 17:45:27.218	\N		\N	\N	video-library	video-hero-subtitle	\N	\N	\N
8f2aef5d-27a3-4f3b-8268-b0075972acd4	Video Ders		11	t	2026-01-22 17:36:22.13	2026-01-22 17:45:27.221	\N		\N	\N	video-library	video-stat2-label	\N	\N	\N
a7493aaf-b96a-4a35-8df2-0e28917ee6c4	50+		12	t	2026-01-22 17:36:22.131	2026-01-22 17:45:27.222	\N		\N	\N	video-library	video-stat3-value	\N	\N	\N
7c2f9c2d-0b51-4246-a3ed-f93187e8eb8c	Öğretmen		13	t	2026-01-22 17:36:22.131	2026-01-22 17:45:27.223	\N		\N	\N	video-library	video-stat3-label	\N	\N	\N
1a8243ce-2629-4f9d-a2d5-b73c122071fc	100K+		14	t	2026-01-22 17:36:22.132	2026-01-22 17:45:27.223	\N		\N	\N	video-library	video-stat4-value	\N	\N	\N
02da7998-1d89-459b-820a-6b18799df8ce	İzlenme		15	t	2026-01-22 17:36:22.132	2026-01-22 17:45:27.224	\N		\N	\N	video-library	video-stat4-label	\N	\N	\N
f60986ab-9974-4ff8-81ef-6b0731cc15fb	Ders		16	t	2026-01-22 17:36:22.133	2026-01-22 17:45:27.224	\N		\N	\N	video-library	video-categories-title	\N	\N	\N
dd2257df-808f-4ca7-b964-88dc97f331ff	Kategorileri		17	t	2026-01-22 17:36:22.134	2026-01-22 17:45:27.224	\N		\N	\N	video-library	video-categories-title-highlight	\N	\N	\N
5a63cb07-f611-4021-b84d-f65648e78967		Tüm derslere ait kapsamlı video içerikleri	18	t	2026-01-22 17:36:22.134	2026-01-22 17:45:27.225	\N		\N	\N	video-library	video-categories-subtitle	\N	\N	\N
9fdcec65-4913-4d7e-900d-8d67e1609dc4	Video Kütüphanesi		19	t	2026-01-22 17:36:22.135	2026-01-22 17:45:27.225	\N		\N	\N	video-library	video-features-title	\N	\N	\N
a921559c-16e8-44e5-9464-6fd5e2a7001a	Özellikleri		20	t	2026-01-22 17:36:22.135	2026-01-22 17:45:27.226	\N		\N	\N	video-library	video-features-title-highlight	\N	\N	\N
22344a1c-dd35-4fc6-bc64-d26665bf496d	\N	İstanbul Genel Merkez Ofisi	6	t	2026-01-22 17:16:02.071	2026-01-22 17:45:27.2	\N	\N	\N	\N	contact	contact-address-line1	\N	\N	\N
8e21700d-f0ab-46ba-939b-a00cbe41e32b	\N	Beşiktaş Plaza, Kat: 5	7	t	2026-01-22 17:16:02.071	2026-01-22 17:45:27.2	\N	\N	\N	\N	contact	contact-address-line2	\N	\N	\N
797222b5-c07a-4b29-8547-568cf2be0b3a	\N	Beşiktaş / İstanbul	8	t	2026-01-22 17:16:02.072	2026-01-22 17:45:27.201	\N	\N	\N	\N	contact	contact-address-line3	\N	\N	\N
918ff46b-d164-4ffd-b15e-ada0889af5a2	Telefon	\N	9	t	2026-01-22 17:16:02.072	2026-01-22 17:45:27.201	\N	\N	\N	\N	contact	contact-phone-title	\N	\N	\N
93dfb6c4-84da-4554-9159-5f4fc8260f13	\N	destek@hocalarageldik.com	14	t	2026-01-22 17:16:02.074	2026-01-22 17:45:27.204	\N	\N	\N	\N	contact	contact-email-line2	\N	\N	\N
0782afee-2d90-4235-b37f-704a25b3ebe6	Çalışma Saatleri	\N	15	t	2026-01-22 17:16:02.074	2026-01-22 17:45:27.204	\N	\N	\N	\N	contact	contact-hours-title	\N	\N	\N
b7d1e6d3-d510-4fba-80b5-8a1dec0cd445	\N	Pazartesi - Cuma: 09:00 - 18:00	16	t	2026-01-22 17:16:02.075	2026-01-22 17:45:27.204	\N	\N	\N	\N	contact	contact-hours-line1	\N	\N	\N
5f3cc803-45f0-4857-8474-d8bb396febd9	\N	Cumartesi: 10:00 - 16:00	17	t	2026-01-22 17:16:02.075	2026-01-22 17:45:27.205	\N	\N	\N	\N	contact	contact-hours-line2	\N	\N	\N
94c35254-9edc-4db5-b54f-37047e25b10c	\N	Pazar: AÇIK	18	t	2026-01-22 17:16:02.076	2026-01-22 17:45:27.205	\N	\N	\N	\N	contact	contact-hours-line3	\N	\N	\N
8a0eace6-f07c-4296-9385-9a40b5d54c67	Sosyal Medya	\N	19	t	2026-01-22 17:16:02.077	2026-01-22 17:45:27.206	\N	\N	\N	\N	contact	contact-social-title	\N	\N	\N
3402ba45-5902-4139-ae1b-d1c6c2629cac	HD Kalite		21	t	2026-01-22 17:36:22.135	2026-01-22 17:45:27.226	\N		\N	\N	video-library	video-feature1-title	\N	\N	\N
a659028c-fb04-4d10-a356-4777418e5eef		Tüm videolar Full HD kalitede, net görüntü ve ses ile hazırlanmıştır.	22	t	2026-01-22 17:36:22.136	2026-01-22 17:45:27.227	\N		\N	\N	video-library	video-feature1-desc	\N	\N	\N
e3186ff0-4ea1-40e7-ac5a-18203f4ae5a8	Konu Bazlı		23	t	2026-01-22 17:36:22.137	2026-01-22 17:45:27.227	\N		\N	\N	video-library	video-feature2-title	\N	\N	\N
e75e9d0c-927f-4771-8a26-4046b93fcebe		Her konu detaylı şekilde işlenmiş, adım adım anlatım ile öğrenin.	24	t	2026-01-22 17:36:22.137	2026-01-22 17:45:27.227	\N		\N	\N	video-library	video-feature2-desc	\N	\N	\N
64243014-51c8-4f49-8c93-8fdc1ab58a6d	Sınırsız Erişim		25	t	2026-01-22 17:36:22.137	2026-01-22 17:45:27.228	\N		\N	\N	video-library	video-feature3-title	\N	\N	\N
e68992fb-ae8b-4722-b790-7fecf115573e		7/24 erişim, istediğiniz zaman istediğiniz yerden izleyebilirsiniz.	26	t	2026-01-22 17:36:22.138	2026-01-22 17:45:27.228	\N		\N	\N	video-library	video-feature3-desc	\N	\N	\N
a7ea7e58-5620-4018-9067-93dba5343727	Uzman Öğretmenler		27	t	2026-01-22 17:36:22.138	2026-01-22 17:45:27.228	\N		\N	\N	video-library	video-feature4-title	\N	\N	\N
e5e75c1e-13f9-4893-bf9a-42f66dc5a3a8		Alanında uzman öğretmenler tarafından hazırlanmış içerikler.	28	t	2026-01-22 17:36:22.139	2026-01-22 17:45:27.229	\N		\N	\N	video-library	video-feature4-desc	\N	\N	\N
f356a5fa-fd33-4173-a9fd-1c9fb232a4c5	İnteraktif		29	t	2026-01-22 17:36:22.139	2026-01-22 17:45:27.229	\N		\N	\N	video-library	video-feature5-title	\N	\N	\N
62387054-70e4-413c-9c8b-9aad40da30f2		Videolar üzerinde not alma, işaretleme ve tekrar izleme özellikleri.	30	t	2026-01-22 17:36:22.139	2026-01-22 17:45:27.23	\N		\N	\N	video-library	video-feature5-desc	\N	\N	\N
96117256-19ad-4c2b-87fc-1cdeab6da016	Sürekli Güncelleme		31	t	2026-01-22 17:36:22.14	2026-01-22 17:45:27.23	\N		\N	\N	video-library	video-feature6-title	\N	\N	\N
4480c102-2702-4ee8-a6a7-9c578a49982e		Her hafta yeni videolar ekleniyor, içerik sürekli genişliyor.	32	t	2026-01-22 17:36:22.14	2026-01-22 17:45:27.23	\N		\N	\N	video-library	video-feature6-desc	\N	\N	\N
d85ea6e0-d690-4ced-ac58-a5128bfa6335	Binlerce Video Derse		33	t	2026-01-22 17:36:22.141	2026-01-22 17:45:27.231	\N		\N	\N	video-library	video-cta-title	\N	\N	\N
fb578c2e-4d82-4bd1-841f-e7941034cabf	Hemen Erişin		34	t	2026-01-22 17:36:22.141	2026-01-22 17:45:27.231	\N		\N	\N	video-library	video-cta-title-highlight	\N	\N	\N
a192c5cf-f4f5-4b44-86c2-a84d7382f6ba		Kayıt olun ve 5000+ saat video içeriğe sınırsız erişim kazanın.	35	t	2026-01-22 17:36:22.142	2026-01-22 17:45:27.232	\N		\N	\N	video-library	video-cta-subtitle	\N	\N	\N
944ca870-f40f-4621-a0d3-64852505bfe7			36	t	2026-01-22 17:36:22.142	2026-01-22 17:45:27.233	\N	Video Galerisine Git	\N	\N	video-library	video-cta-button1	\N	\N	\N
8560b158-8f8f-46f5-a9d0-bb01d77ac292			37	t	2026-01-22 17:36:22.143	2026-01-22 17:45:27.233	\N	Hemen Kayıt Ol	\N	\N	video-library	video-cta-button2	\N	\N	\N
89b10c3b-9461-4047-aa67-ac2a3363af32	Örnek Ders Videolarıdd		1	t	2026-01-22 17:45:27.241	2026-01-22 17:45:27.241	\N		\N	\N	video-gallery	video-gallery-hero-badge	\N	\N	\N
2d66c36f-5807-4598-a41e-06c14feff2e8	Örnek Ders Videoları		1	t	2026-01-22 17:40:06.174	2026-01-22 17:40:06.174	\N		\N	\N	video-gallery	gallery-hero-badge	\N	\N	\N
dbe93351-d664-40d1-9c54-a9c8dc4f7889	Video		2	t	2026-01-22 17:45:27.243	2026-01-22 17:45:27.243	\N		\N	\N	video-gallery	video-gallery-hero-title	\N	\N	\N
567c9714-7f7d-49b0-bf0b-e0cfff480655	Video		2	t	2026-01-22 17:40:06.181	2026-01-22 17:40:06.181	\N		\N	\N	video-gallery	gallery-hero-title	\N	\N	\N
a721129e-4e9a-45d8-8d2b-f1e52af3de31	Kütüphanemiz		3	t	2026-01-22 17:40:06.185	2026-01-22 17:40:06.185	\N		\N	\N	video-gallery	gallery-hero-title-highlight	\N	\N	\N
916d7f18-6ba0-48e9-9732-6e2c186c4165	Kütüphanemiz		3	t	2026-01-22 17:45:27.244	2026-01-22 17:45:27.244	\N		\N	\N	video-gallery	video-gallery-hero-title-highlight	\N	\N	\N
286403a7-be35-483f-b00f-c0bd7dd630ad		5000+ saatlik profesyonel ders videoları ile akademik başarınızı artırın.	4	t	2026-01-22 17:40:06.186	2026-01-22 17:40:06.186	\N		\N	\N	video-gallery	gallery-hero-subtitle	\N	\N	\N
cc521f1a-0b16-4aad-ba3e-c0211a1680a6		5000+ saatlik profesyonel ders videoları ile akademik başarınızı artırın.	4	t	2026-01-22 17:45:27.244	2026-01-22 17:45:27.244	\N		\N	\N	video-gallery	video-gallery-hero-subtitle	\N	\N	\N
1da01cd8-b8f5-4379-b5e1-b16463328010	Video, ders veya konu ara...		5	t	2026-01-22 17:45:27.245	2026-01-22 17:45:27.245	\N		\N	\N	video-gallery	video-gallery-search-placeholder	\N	\N	\N
d52ca499-9b77-4eef-8300-2233a423dec7	Video, ders veya konu ara...		5	t	2026-01-22 17:40:06.187	2026-01-22 17:40:06.187	\N		\N	\N	video-gallery	gallery-search-placeholder	\N	\N	\N
299a4fec-ba69-4528-8e73-e54c347128ae	Aradığınız kriterlere uygun video bulunamadı.		6	t	2026-01-22 17:40:06.188	2026-01-22 17:40:06.188	\N		\N	\N	video-gallery	gallery-empty-message	\N	\N	\N
c3d0515b-32d9-488a-90dc-7ab31bab3f13	Tüm Videolar		6	t	2026-01-22 17:45:27.246	2026-01-22 17:45:27.246	\N		\N	\N	video-gallery	video-gallery-tab-all	\N	\N	\N
90acac20-ddbd-4471-bd79-64da0c5d8b86	YKS TYT		7	t	2026-01-22 17:45:27.246	2026-01-22 17:45:27.246	\N		\N	\N	video-gallery	video-gallery-tab-yks-tyt	\N	\N	\N
6a4d5ca5-8922-46b3-be68-3dd4dfa1027f	YKS AYT		8	t	2026-01-22 17:45:27.246	2026-01-22 17:45:27.246	\N		\N	\N	video-gallery	video-gallery-tab-yks-ayt	\N	\N	\N
40b92a33-e0a2-4884-ae98-6b3619580f6a	LGS		9	t	2026-01-22 17:45:27.247	2026-01-22 17:45:27.247	\N		\N	\N	video-gallery	video-gallery-tab-lgs	\N	\N	\N
b49ae033-602f-4e5a-bdd2-e2870bee3640	KPSS		10	t	2026-01-22 17:45:27.247	2026-01-22 17:45:27.247	\N		\N	\N	video-gallery	video-gallery-tab-kpss	\N	\N	\N
beb38c5a-5cbd-4120-9e8b-cda2dc254424	Aradığınız kriterlere uygun video bulunamadı.		11	t	2026-01-22 17:45:27.248	2026-01-22 17:45:27.248	\N		\N	\N	video-gallery	video-gallery-empty-message	\N	\N	\N
4acb00fa-d501-4db6-bfb5-c89ab7e5055f	Dijital Eğitim Platformudx	Yapay zeka destekli öğrenme deneyimi	0	t	2026-01-21 15:38:16.819	2026-01-21 15:38:16.819	/dijital-platform	Platform'u Keşfet	\N	\N	digital	hero	\N	\N	\N
ddb20b98-d9cd-4712-b834-806b138d6cfe	\N	\N	0	t	2026-01-24 20:27:01.39	2026-01-24 20:27:01.39	\N	\N	\N	\N	about	seo	asdadaasdada	asdadadasdasdsa	seasda
0c7732d4-e6c6-4df9-8bde-57cd435fe472	\N	\N	0	t	2026-01-24 20:30:21.721	2026-01-24 20:30:21.721	\N	\N	\N	\N	branches	seo	aasd	asd	asd
ee7ae535-32e7-4372-b722-1258c1585f0d	\N	\N	0	t	2026-01-24 20:30:58.992	2026-01-24 20:30:58.992	\N	\N	\N	\N	teachers	seo	dsdsa	asd	asa
72de014f-8dbf-4a89-8114-f20ce529eebc	aSs	\N	3	t	2026-01-25 09:26:15.583	2026-01-25 09:26:15.583		\N	\N	\N	home	header-topbar-link-1769333175535	\N	\N	\N
\.


--
-- Data for Name: Lead; Type: TABLE DATA; Schema: public; Owner: hocalara_admin
--

COPY public."Lead" (id, name, surname, phone, email, "branchId", status, notes, "createdAt", "updatedAt") FROM stdin;
5fb497d2-d815-45a7-b55d-51900347ce96	Yiğit	Selçuk	055412344234	ornek@gmail.com	38aeca3e-8805-44e8-a87f-d87acabc0033	NEW	\N	2026-01-24 13:32:03.338	2026-01-24 13:32:03.338
10d3e62e-c17f-4bb4-9066-0baf271c40a1	sdfds	dsfdsf	123123412312	asdada@gmailc.om	38aeca3e-8805-44e8-a87f-d87acabc0033	REJECTED	\N	2026-01-24 15:33:56.541	2026-01-24 15:39:34.132
e9fc589a-fbf0-49c6-8d4b-493f7510c48e	sdads	-	123213213	asdaas@xn--ghmao-mdb.cp	\N	NEW	\N	2026-01-24 16:25:50.34	2026-01-24 16:25:50.34
\.


--
-- Data for Name: Media; Type: TABLE DATA; Schema: public; Owner: hocalara_admin
--

COPY public."Media" (id, type, filename, "originalName", "mimeType", size, url, thumbnail, "pageId", alt, caption, "createdAt", "updatedAt") FROM stdin;
1175cf4f-9e7f-4153-b9c9-d66825671104	IMAGE	1769017507090-30489801.jpeg	images.jpeg	image/jpeg	11114	/uploads/1769017507090-30489801.jpeg	/uploads/thumb-1769017507090-30489801.jpeg	\N	\N	\N	2026-01-21 17:45:07.113	2026-01-21 17:45:07.113
3ffa8b89-9602-4193-b6d6-64ab3042d13e	IMAGE	1769017525886-706214747.jpeg	images.jpeg	image/jpeg	11114	/uploads/1769017525886-706214747.jpeg	/uploads/thumb-1769017525886-706214747.jpeg	\N	\N	\N	2026-01-21 17:45:25.896	2026-01-21 17:45:25.896
2ad13eee-2e39-4c80-a2e5-f8d0ee0495c4	IMAGE	1769017540975-385019996.jpg	10826111352882.jpg	image/jpeg	23190	/uploads/1769017540975-385019996.jpg	/uploads/thumb-1769017540975-385019996.jpg	\N	\N	\N	2026-01-21 17:45:40.986	2026-01-21 17:45:40.986
95933b84-fd0d-4947-b540-82c4317ce22a	IMAGE	1769017559570-670588552.jpeg	images.jpeg	image/jpeg	11114	/uploads/1769017559570-670588552.jpeg	/uploads/thumb-1769017559570-670588552.jpeg	\N	\N	\N	2026-01-21 17:45:59.578	2026-01-21 17:45:59.578
1bbbf590-d9bc-4014-aaf5-288628b2fe07	IMAGE	1769017731540-57626579.jpg	10826111352882.jpg	image/jpeg	23190	/uploads/1769017731540-57626579.jpg	/uploads/thumb-1769017731540-57626579.jpg	\N	\N	\N	2026-01-21 17:48:51.549	2026-01-21 17:48:51.549
4309dcfb-f6ea-47bf-9621-412c71950106	IMAGE	1769017852588-499224677.jpg	10826111352882.jpg	image/jpeg	23190	/uploads/1769017852588-499224677.jpg	/uploads/thumb-1769017852588-499224677.jpg	\N	\N	\N	2026-01-21 17:50:52.623	2026-01-21 17:50:52.623
afb971e4-4600-428e-ad66-341c19d4bf58	IMAGE	1769017980743-614444383.jpg	10826111352882.jpg	image/jpeg	23190	/uploads/1769017980743-614444383.jpg	/uploads/thumb-1769017980743-614444383.jpg	\N	\N	\N	2026-01-21 17:53:00.753	2026-01-21 17:53:00.753
9de673fa-890a-429d-884b-f983f0893774	IMAGE	1769019596733-961689994.jpeg	images.jpeg	image/jpeg	11114	/uploads/1769019596733-961689994.jpeg	/uploads/thumb-1769019596733-961689994.jpeg	\N	\N	\N	2026-01-21 18:19:56.745	2026-01-21 18:19:56.745
35cbf6be-cf4a-4995-bddc-d1aaed6ea3bb	IMAGE	1769019604628-552406033.jpeg	images.jpeg	image/jpeg	11114	/uploads/1769019604628-552406033.jpeg	/uploads/thumb-1769019604628-552406033.jpeg	\N	\N	\N	2026-01-21 18:20:04.66	2026-01-21 18:20:04.66
85cd3fed-9a9f-4043-b58e-3c1887e9c354	IMAGE	1769025334564-526220436.jpg	10826111352882.jpg	image/jpeg	23190	/uploads/1769025334564-526220436.jpg	/uploads/thumb-1769025334564-526220436.jpg	\N	\N	\N	2026-01-21 19:55:34.578	2026-01-21 19:55:34.578
9983d662-e322-4816-b54c-927128f9e4ab	IMAGE	1769067196413-410355349.jpeg	images.jpeg	image/jpeg	11114	/uploads/1769067196413-410355349.jpeg	/uploads/thumb-1769067196413-410355349.jpeg	\N	\N	\N	2026-01-22 07:33:16.429	2026-01-22 07:33:16.429
20d5cb2a-2145-4fab-9c17-caee05209572	IMAGE	1769067204729-494346628.jpeg	images.jpeg	image/jpeg	11114	/uploads/1769067204729-494346628.jpeg	/uploads/thumb-1769067204729-494346628.jpeg	\N	\N	\N	2026-01-22 07:33:24.762	2026-01-22 07:33:24.762
d52e0a04-5d0f-4960-83ea-9d90571363f9	IMAGE	1769067265130-660666958.jpeg	images.jpeg	image/jpeg	11114	/uploads/1769067265130-660666958.jpeg	/uploads/thumb-1769067265130-660666958.jpeg	\N	\N	\N	2026-01-22 07:34:25.165	2026-01-22 07:34:25.165
2d67aa51-7127-4136-a34c-911715c571e4	IMAGE	1769067321045-636903078.jpeg	images.jpeg	image/jpeg	11114	/uploads/1769067321045-636903078.jpeg	/uploads/thumb-1769067321045-636903078.jpeg	\N	\N	\N	2026-01-22 07:35:21.077	2026-01-22 07:35:21.077
1da29502-dc47-4021-a3bb-570ad0601e4f	IMAGE	1769067397323-522770765.jpeg	images.jpeg	image/jpeg	11114	/uploads/1769067397323-522770765.jpeg	/uploads/thumb-1769067397323-522770765.jpeg	\N	\N	\N	2026-01-22 07:36:37.355	2026-01-22 07:36:37.355
83dc684b-712d-452e-ab34-d6752079b9f3	IMAGE	1769067938765-248225554.jpeg	images.jpeg	image/jpeg	11114	/uploads/1769067938765-248225554.jpeg	/uploads/thumb-1769067938765-248225554.jpeg	\N	\N	\N	2026-01-22 07:45:38.772	2026-01-22 07:45:38.772
dec21404-2ce0-4756-84e6-c12c58b534c1	IMAGE	1769078185569-986785922.jpeg	images.jpeg	image/jpeg	11114	/uploads/1769078185569-986785922.jpeg	/uploads/thumb-1769078185569-986785922.jpeg	\N	\N	\N	2026-01-22 10:36:25.577	2026-01-22 10:36:25.577
ad7fc1d4-0a08-43b4-9e61-7c6a119b63d8	IMAGE	1769083420336-973309985.jpg	19602JHKH.jpg	image/jpeg	816864	/uploads/1769083420336-973309985.jpg	/uploads/thumb-1769083420336-973309985.jpg	\N	\N	\N	2026-01-22 12:03:40.362	2026-01-22 12:03:40.362
08edc988-1f3a-45ad-bd9f-1048747a98ef	IMAGE	1769083624607-436972825.jpg	127-1278065_11807607-10152879337512101-6668612856123603308-o-scuba-diving-wallpaper-4k.jpg	image/jpeg	79114	/uploads/1769083624607-436972825.jpg	/uploads/thumb-1769083624607-436972825.jpg	\N	\N	\N	2026-01-22 12:07:04.618	2026-01-22 12:07:04.618
79d71a9c-1868-47b4-b0b0-c0d64179a078	IMAGE	1769092396340-814851438.jpeg	images.jpeg	image/jpeg	11114	/uploads/1769092396340-814851438.jpeg	/uploads/thumb-1769092396340-814851438.jpeg	\N	\N	\N	2026-01-22 14:33:16.352	2026-01-22 14:33:16.352
977095c0-935e-43b7-9fee-ef3110c93bb6	IMAGE	1769092620247-777178766.jpeg	images.jpeg	image/jpeg	11114	/uploads/1769092620247-777178766.jpeg	/uploads/thumb-1769092620247-777178766.jpeg	\N	\N	\N	2026-01-22 14:37:00.256	2026-01-22 14:37:00.256
89fac017-23ed-4699-8bd0-5fa8ccd1f952	IMAGE	1769092996941-918647631.jpeg	images.jpeg	image/jpeg	11114	/uploads/1769092996941-918647631.jpeg	/uploads/thumb-1769092996941-918647631.jpeg	\N	\N	\N	2026-01-22 14:43:16.949	2026-01-22 14:43:16.949
6e1e63bf-ab4a-4b64-a541-a9ccb9062bb6	IMAGE	1769093397557-651928967.jpeg	images.jpeg	image/jpeg	11114	/uploads/1769093397557-651928967.jpeg	/uploads/thumb-1769093397557-651928967.jpeg	\N	\N	\N	2026-01-22 14:49:57.561	2026-01-22 14:49:57.561
5ef1b058-92b9-4833-b383-2797ed8fdbdb	IMAGE	1769093909411-158002793.jpeg	images.jpeg	image/jpeg	11114	/uploads/1769093909411-158002793.jpeg	/uploads/thumb-1769093909411-158002793.jpeg	\N	\N	\N	2026-01-22 14:58:29.421	2026-01-22 14:58:29.421
133eed64-dcf4-420f-9845-4b82e0720f94	IMAGE	1769094032961-653956272.jpeg	images.jpeg	image/jpeg	11114	/uploads/1769094032961-653956272.jpeg	/uploads/thumb-1769094032961-653956272.jpeg	\N	\N	\N	2026-01-22 15:00:32.968	2026-01-22 15:00:32.968
b98f0776-5486-41f6-ae7d-aa5d3eec6e7c	IMAGE	1769094808515-549573226.jpeg	images.jpeg	image/jpeg	11114	/uploads/1769094808515-549573226.jpeg	/uploads/thumb-1769094808515-549573226.jpeg	\N	\N	\N	2026-01-22 15:13:28.524	2026-01-22 15:13:28.524
1592dadf-a65a-4a88-81c4-0f2420088bd3	IMAGE	1769094859582-194051350.jpeg	images.jpeg	image/jpeg	11114	/uploads/1769094859582-194051350.jpeg	/uploads/thumb-1769094859582-194051350.jpeg	\N	\N	\N	2026-01-22 15:14:19.589	2026-01-22 15:14:19.589
5a12e941-992d-49c3-9002-4d8d1d2c1edc	IMAGE	1769094886082-327406279.jpg	127-1278065_11807607-10152879337512101-6668612856123603308-o-scuba-diving-wallpaper-4k.jpg	image/jpeg	79114	/uploads/1769094886082-327406279.jpg	/uploads/thumb-1769094886082-327406279.jpg	\N	\N	\N	2026-01-22 15:14:46.092	2026-01-22 15:14:46.092
447c8795-219e-44db-8870-7a38da65b708	IMAGE	1769095000030-502731786.jpeg	images.jpeg	image/jpeg	11114	/uploads/1769095000030-502731786.jpeg	/uploads/thumb-1769095000030-502731786.jpeg	\N	\N	\N	2026-01-22 15:16:40.037	2026-01-22 15:16:40.037
50e7d9af-bcce-4738-a69d-d582ea6ee245	IMAGE	1769095041930-237525336.jpeg	images.jpeg	image/jpeg	11114	/uploads/1769095041930-237525336.jpeg	/uploads/thumb-1769095041930-237525336.jpeg	\N	\N	\N	2026-01-22 15:17:21.937	2026-01-22 15:17:21.937
17166159-65e8-47b4-98be-6eae577472e6	IMAGE	1769095062180-624814765.jpeg	images.jpeg	image/jpeg	11114	/uploads/1769095062180-624814765.jpeg	/uploads/thumb-1769095062180-624814765.jpeg	\N	\N	\N	2026-01-22 15:17:42.186	2026-01-22 15:17:42.186
f38ed58c-b1b3-479a-9120-4af93c34ec81	IMAGE	1769095171654-259117470.jpeg	images.jpeg	image/jpeg	11114	/uploads/1769095171654-259117470.jpeg	/uploads/thumb-1769095171654-259117470.jpeg	\N	\N	\N	2026-01-22 15:19:31.666	2026-01-22 15:19:31.666
f36428af-f5b7-4b9c-9801-579404e7b9c5	IMAGE	1769095385612-463157235.jpeg	images.jpeg	image/jpeg	11114	/uploads/1769095385612-463157235.jpeg	/uploads/thumb-1769095385612-463157235.jpeg	\N	\N	\N	2026-01-22 15:23:05.622	2026-01-22 15:23:05.622
cbecd6d6-c147-4ed7-b74a-2e6262e6ed33	IMAGE	1769098101195-422062042.jpeg	images.jpeg	image/jpeg	11114	/uploads/1769098101195-422062042.jpeg	/uploads/thumb-1769098101195-422062042.jpeg	\N	\N	\N	2026-01-22 16:08:21.207	2026-01-22 16:08:21.207
1bb0f363-3072-4532-b00a-717d70e5dc47	IMAGE	1769099844581-670266775.jpg	127-1278065_11807607-10152879337512101-6668612856123603308-o-scuba-diving-wallpaper-4k.jpg	image/jpeg	79114	/uploads/1769099844581-670266775.jpg	/uploads/thumb-1769099844581-670266775.jpg	\N	\N	\N	2026-01-22 16:37:24.592	2026-01-22 16:37:24.592
82454790-8a81-4376-a725-8b971a000fcc	IMAGE	1769100074273-627295304.jpg	19602JHKH.jpg	image/jpeg	816864	/uploads/1769100074273-627295304.jpg	/uploads/thumb-1769100074273-627295304.jpg	\N	\N	\N	2026-01-22 16:41:14.296	2026-01-22 16:41:14.296
686dd84c-3ae8-48f3-a363-60e17292531f	IMAGE	1769146576789-528896604.jpg	127-1278065_11807607-10152879337512101-6668612856123603308-o-scuba-diving-wallpaper-4k.jpg	image/jpeg	79114	/uploads/1769146576789-528896604.jpg	/uploads/thumb-1769146576789-528896604.jpg	\N	\N	\N	2026-01-23 05:36:16.8	2026-01-23 05:36:16.8
7838bbb3-b470-40fe-9bca-8255ac3712d0	IMAGE	1769148813566-962382040.jpg	127-1278065_11807607-10152879337512101-6668612856123603308-o-scuba-diving-wallpaper-4k.jpg	image/jpeg	79114	/uploads/1769148813566-962382040.jpg	/uploads/thumb-1769148813566-962382040.jpg	\N	\N	\N	2026-01-23 06:13:33.58	2026-01-23 06:13:33.58
b1cf34ae-0dd5-4439-8198-ee38219d42c6	IMAGE	1769148868081-512705028.jpg	19602JHKH.jpg	image/jpeg	816864	/uploads/1769148868081-512705028.jpg	/uploads/thumb-1769148868081-512705028.jpg	\N	\N	\N	2026-01-23 06:14:28.102	2026-01-23 06:14:28.102
d5ac3813-2348-4e4a-b06b-9723d9a281bc	IMAGE	1769148911176-513459797.jpg	19602JHKH.jpg	image/jpeg	816864	/uploads/1769148911176-513459797.jpg	/uploads/thumb-1769148911176-513459797.jpg	\N	\N	\N	2026-01-23 06:15:11.202	2026-01-23 06:15:11.202
04981935-0788-4c0b-8197-efc4034528ce	IMAGE	1769149063636-444170461.jpg	127-1278065_11807607-10152879337512101-6668612856123603308-o-scuba-diving-wallpaper-4k.jpg	image/jpeg	79114	/uploads/1769149063636-444170461.jpg	/uploads/thumb-1769149063636-444170461.jpg	\N	\N	\N	2026-01-23 06:17:43.646	2026-01-23 06:17:43.646
f1a971b4-a563-4920-83d9-fc10f3b157af	IMAGE	1769149066788-708473835.jpg	19602JHKH.jpg	image/jpeg	816864	/uploads/1769149066788-708473835.jpg	/uploads/thumb-1769149066788-708473835.jpg	\N	\N	\N	2026-01-23 06:17:46.809	2026-01-23 06:17:46.809
2a8aebb1-1966-4898-b073-85dc87b9be5c	IMAGE	1769149070036-93437293.jpeg	_a2508adf-66c2-4bd4-85a3-652e2e607fa2.jpeg	image/jpeg	118803	/uploads/1769149070036-93437293.jpeg	/uploads/thumb-1769149070036-93437293.jpeg	\N	\N	\N	2026-01-23 06:17:50.046	2026-01-23 06:17:50.046
996aec65-e15d-489d-bb73-0dea5f3b57c4	IMAGE	1769149832857-978831571.jpg	127-1278065_11807607-10152879337512101-6668612856123603308-o-scuba-diving-wallpaper-4k.jpg	image/jpeg	79114	/uploads/1769149832857-978831571.jpg	/uploads/thumb-1769149832857-978831571.jpg	\N	\N	\N	2026-01-23 06:30:32.867	2026-01-23 06:30:32.867
4dc49ab2-2c9e-4758-9304-8a4f688e0d6f	IMAGE	1769149835227-742642441.jpg	19602JHKH.jpg	image/jpeg	816864	/uploads/1769149835227-742642441.jpg	/uploads/thumb-1769149835227-742642441.jpg	\N	\N	\N	2026-01-23 06:30:35.248	2026-01-23 06:30:35.248
15936050-acd8-4390-88cb-bf51a4040276	IMAGE	1769149837353-248788772.jpg	127-1278065_11807607-10152879337512101-6668612856123603308-o-scuba-diving-wallpaper-4k.jpg	image/jpeg	79114	/uploads/1769149837353-248788772.jpg	/uploads/thumb-1769149837353-248788772.jpg	\N	\N	\N	2026-01-23 06:30:37.362	2026-01-23 06:30:37.362
f334a5bc-b8d5-44ea-bcb9-0c1e05fb8363	IMAGE	1769149927446-799617088.jpg	127-1278065_11807607-10152879337512101-6668612856123603308-o-scuba-diving-wallpaper-4k.jpg	image/jpeg	79114	/uploads/1769149927446-799617088.jpg	/uploads/thumb-1769149927446-799617088.jpg	\N	\N	\N	2026-01-23 06:32:07.454	2026-01-23 06:32:07.454
87bfd0ea-2508-4d0d-a273-80d75e0b228a	IMAGE	1769149929889-752524400.jpg	19602JHKH.jpg	image/jpeg	816864	/uploads/1769149929889-752524400.jpg	/uploads/thumb-1769149929889-752524400.jpg	\N	\N	\N	2026-01-23 06:32:09.909	2026-01-23 06:32:09.909
3b8be462-e5a2-414e-b0f8-0e08495b8c05	IMAGE	1769149932493-482124623.jpeg	_a2508adf-66c2-4bd4-85a3-652e2e607fa2.jpeg	image/jpeg	118803	/uploads/1769149932493-482124623.jpeg	/uploads/thumb-1769149932493-482124623.jpeg	\N	\N	\N	2026-01-23 06:32:12.501	2026-01-23 06:32:12.501
5fb3cada-14f9-48f4-8d57-3a33bf38536a	IMAGE	1769150187452-948028599.jpg	127-1278065_11807607-10152879337512101-6668612856123603308-o-scuba-diving-wallpaper-4k.jpg	image/jpeg	79114	/uploads/1769150187452-948028599.jpg	/uploads/thumb-1769150187452-948028599.jpg	\N	\N	\N	2026-01-23 06:36:27.46	2026-01-23 06:36:27.46
dc39ae5f-fd7b-470d-b865-3de2aef92bbc	IMAGE	1769150189945-789821895.jpg	19602JHKH.jpg	image/jpeg	816864	/uploads/1769150189945-789821895.jpg	/uploads/thumb-1769150189945-789821895.jpg	\N	\N	\N	2026-01-23 06:36:29.965	2026-01-23 06:36:29.965
dd7f24b5-03e4-4285-b1b6-72d7e87ae6fc	IMAGE	1769150192409-430924694.jpeg	_a2508adf-66c2-4bd4-85a3-652e2e607fa2.jpeg	image/jpeg	118803	/uploads/1769150192409-430924694.jpeg	/uploads/thumb-1769150192409-430924694.jpeg	\N	\N	\N	2026-01-23 06:36:32.418	2026-01-23 06:36:32.418
371a36ef-5631-4284-9a2d-91e126c87305	IMAGE	1769156279196-678727312.jpg	1655801016830.jpg	image/jpeg	712560	/uploads/1769156279196-678727312.jpg	/uploads/thumb-1769156279196-678727312.jpg	\N	\N	\N	2026-01-23 08:17:59.218	2026-01-23 08:17:59.218
4a40cde8-4dd3-4816-b402-d6c1b07a04b4	IMAGE	1769156500975-113166778.jpg	1655801016830.jpg	image/jpeg	712560	/uploads/1769156500975-113166778.jpg	/uploads/thumb-1769156500975-113166778.jpg	\N	\N	\N	2026-01-23 08:21:40.999	2026-01-23 08:21:40.999
22b38ae0-a313-4212-8227-b17def6a4b69	IMAGE	1769186726290-921299469.jpg	10826111352882.jpg	image/jpeg	23190	/uploads/1769186726290-921299469.jpg	/uploads/thumb-1769186726290-921299469.jpg	\N	\N	\N	2026-01-23 16:45:26.305	2026-01-23 16:45:26.305
5cd28363-bb9d-4b85-8b20-2d8147a6bce8	IMAGE	1769186731473-757421767.jpg	260420677_904969586812042_1421742849448889402_n.jpg	image/jpeg	78538	/uploads/1769186731473-757421767.jpg	/uploads/thumb-1769186731473-757421767.jpg	\N	\N	\N	2026-01-23 16:45:31.484	2026-01-23 16:45:31.484
48b5c8b5-1245-4e6b-8dbe-fcf9297a8986	IMAGE	1769186737785-796155916.jpg	127-1278065_11807607-10152879337512101-6668612856123603308-o-scuba-diving-wallpaper-4k.jpg	image/jpeg	79114	/uploads/1769186737785-796155916.jpg	/uploads/thumb-1769186737785-796155916.jpg	\N	\N	\N	2026-01-23 16:45:37.799	2026-01-23 16:45:37.799
9ebbdc03-78ed-4b7e-8acd-00903d9027d1	IMAGE	1769196754804-967823476.jpg	127-1278065_11807607-10152879337512101-6668612856123603308-o-scuba-diving-wallpaper-4k.jpg	image/jpeg	79114	/uploads/1769196754804-967823476.jpg	/uploads/thumb-1769196754804-967823476.jpg	\N	\N	\N	2026-01-23 19:32:34.823	2026-01-23 19:32:34.823
ed5dc3de-bd97-4279-b493-8aab01634c3a	IMAGE	1769196860710-605311159.jpeg	_a2508adf-66c2-4bd4-85a3-652e2e607fa2.jpeg	image/jpeg	118803	/uploads/1769196860710-605311159.jpeg	/uploads/thumb-1769196860710-605311159.jpeg	\N	\N	\N	2026-01-23 19:34:20.722	2026-01-23 19:34:20.722
0546943f-95ce-46d0-9170-c66691a604ad	IMAGE	1769198257087-924961232.jpg	1655801016830.jpg	image/jpeg	712560	/uploads/1769198257087-924961232.jpg	/uploads/thumb-1769198257087-924961232.jpg	\N	\N	\N	2026-01-23 19:57:37.117	2026-01-23 19:57:37.117
9ba7bd1c-160b-4788-be15-2df7be3b2613	IMAGE	1769198617774-385606849.jpg	127-1278065_11807607-10152879337512101-6668612856123603308-o-scuba-diving-wallpaper-4k.jpg	image/jpeg	79114	/uploads/1769198617774-385606849.jpg	/uploads/thumb-1769198617774-385606849.jpg	\N	\N	\N	2026-01-23 20:03:37.787	2026-01-23 20:03:37.787
066e753f-b0ea-4a7f-ae01-9ca85d194ae3	IMAGE	1769232394145-524907986.jpg	10826111352882.jpg	image/jpeg	23190	/uploads/1769232394145-524907986.jpg	/uploads/thumb-1769232394145-524907986.jpg	\N	\N	\N	2026-01-24 05:26:34.16	2026-01-24 05:26:34.16
49ba166e-8550-4304-b07f-7deb0d565868	IMAGE	1769233197982-804208985.jpeg	_a2508adf-66c2-4bd4-85a3-652e2e607fa2.jpeg	image/jpeg	118803	/uploads/1769233197982-804208985.jpeg	/uploads/thumb-1769233197982-804208985.jpeg	\N	\N	\N	2026-01-24 05:39:57.996	2026-01-24 05:39:57.996
d0585ed1-5568-4c8b-993a-0c11c7241ced	IMAGE	1769233739099-174388680.png	260420677_904969586812042_1421742849448889402_n-Photoroom.png	image/png	320830	/uploads/1769233739099-174388680.png	/uploads/thumb-1769233739099-174388680.png	\N	\N	\N	2026-01-24 05:48:59.123	2026-01-24 05:48:59.123
06fffd09-009c-470d-8eba-5c0fa3070c0e	IMAGE	1769233870541-439493620.jpg	1655801016830.jpg	image/jpeg	712560	/uploads/1769233870541-439493620.jpg	/uploads/thumb-1769233870541-439493620.jpg	\N	\N	\N	2026-01-24 05:51:10.569	2026-01-24 05:51:10.569
1ab76f6a-49dd-4da9-a196-eb6f1c4a6ee7	IMAGE	1769233957467-942737813.jpg	10826111352882.jpg	image/jpeg	23190	/uploads/1769233957467-942737813.jpg	/uploads/thumb-1769233957467-942737813.jpg	\N	\N	\N	2026-01-24 05:52:37.495	2026-01-24 05:52:37.495
a45cf96d-0d25-497e-b096-f7fc72a49802	IMAGE	1769249894118-824538208.jpg	260420677_904969586812042_1421742849448889402_n.jpg	image/jpeg	78538	/uploads/1769249894118-824538208.jpg	/uploads/thumb-1769249894118-824538208.jpg	\N	\N	\N	2026-01-24 10:18:14.134	2026-01-24 10:18:14.134
c2dd75a5-2b8c-4afc-bf37-493e253d4668	IMAGE	1769250494103-502033893.jpg	1655801016830.jpg	image/jpeg	712560	/uploads/1769250494103-502033893.jpg	/uploads/thumb-1769250494103-502033893.jpg	\N	\N	\N	2026-01-24 10:28:14.128	2026-01-24 10:28:14.128
c55d9d77-c478-48ab-a710-d5b2d865fe24	IMAGE	1769250598175-777273009.jpg	1655801016830.jpg	image/jpeg	712560	/uploads/1769250598175-777273009.jpg	/uploads/thumb-1769250598175-777273009.jpg	\N	\N	\N	2026-01-24 10:29:58.193	2026-01-24 10:29:58.193
c4242c04-1c3b-41e3-a203-584bc24e0d35	IMAGE	1769250629753-877002079.png	ChatGPT Image 21 Haz 2025 10_14_56-3.png	image/png	3237580	/uploads/1769250629753-877002079.png	/uploads/thumb-1769250629753-877002079.png	\N	\N	\N	2026-01-24 10:30:29.853	2026-01-24 10:30:29.853
6304b557-d623-402b-be15-53147633576b	IMAGE	1769250646334-739812208.png	ChatGPT Image 29 Haz 2025 17_24_28-3.png	image/png	1788871	/uploads/1769250646334-739812208.png	/uploads/thumb-1769250646334-739812208.png	\N	\N	\N	2026-01-24 10:30:46.376	2026-01-24 10:30:46.376
42b66fc1-7647-427a-b478-8cd4ea67552a	IMAGE	1769253793623-678396837.jpg	1655801016830.jpg	image/jpeg	712560	/uploads/1769253793623-678396837.jpg	/uploads/thumb-1769253793623-678396837.jpg	\N	\N	\N	2026-01-24 11:23:13.656	2026-01-24 11:23:13.656
7caaed7a-9df9-43f9-9e3f-cfa73058e280	IMAGE	1769254937364-448045755.jpg	1655801016830.jpg	image/jpeg	712560	/uploads/1769254937364-448045755.jpg	/uploads/thumb-1769254937364-448045755.jpg	\N	\N	\N	2026-01-24 11:42:17.391	2026-01-24 11:42:17.391
7165f4f9-8309-44a5-8ce7-f8b6b5ce3b5d	IMAGE	1769255584692-959558239.jpg	127-1278065_11807607-10152879337512101-6668612856123603308-o-scuba-diving-wallpaper-4k.jpg	image/jpeg	79114	/uploads/1769255584692-959558239.jpg	/uploads/thumb-1769255584692-959558239.jpg	\N	\N	\N	2026-01-24 11:53:04.709	2026-01-24 11:53:04.709
176553c9-f970-4ac9-b54f-4b264eb4eac3	IMAGE	1769256197441-393236010.jpg	1655801016830.jpg	image/jpeg	712560	/uploads/1769256197441-393236010.jpg	/uploads/thumb-1769256197441-393236010.jpg	\N	\N	\N	2026-01-24 12:03:17.481	2026-01-24 12:03:17.481
f1945d8a-c10e-4924-bc36-6c044fc8f83a	IMAGE	1769258683025-81945106.jpg	1655801016830.jpg	image/jpeg	712560	/uploads/1769258683025-81945106.jpg	/uploads/thumb-1769258683025-81945106.jpg	\N	\N	\N	2026-01-24 12:44:43.064	2026-01-24 12:44:43.064
1ede3d66-4e3d-4091-b272-3e8af74a786a	IMAGE	1769258997807-5407244.jpg	260420677_904969586812042_1421742849448889402_n.jpg	image/jpeg	78538	/uploads/1769258997807-5407244.jpg	/uploads/thumb-1769258997807-5407244.jpg	\N	\N	\N	2026-01-24 12:49:57.82	2026-01-24 12:49:57.82
f9f90b9e-6de1-4f96-b883-8a8917a230e5	IMAGE	1769270940079-580302749.jpg	260420677_904969586812042_1421742849448889402_n.jpg	image/jpeg	78538	/uploads/1769270940079-580302749.jpg	/uploads/thumb-1769270940079-580302749.jpg	\N	\N	\N	2026-01-24 16:09:00.104	2026-01-24 16:09:00.104
3134f9b7-0a3c-4e3d-9fe9-7bcc5db5df3e	IMAGE	1769407729709-784261839.jpg	1655801016830.jpg	image/jpeg	712560	/uploads/1769407729709-784261839.jpg	/uploads/thumb-1769407729709-784261839.jpg	\N	\N	\N	2026-01-26 06:08:49.739	2026-01-26 06:08:49.739
0bdbb968-0c80-4eb9-a51c-005057ae6fcf	IMAGE	1769407738350-222638415.jpeg	_a2508adf-66c2-4bd4-85a3-652e2e607fa2.jpeg	image/jpeg	118803	/uploads/1769407738350-222638415.jpeg	/uploads/thumb-1769407738350-222638415.jpeg	\N	\N	\N	2026-01-26 06:08:58.36	2026-01-26 06:08:58.36
60272f21-bc33-4367-b5a6-5e943e1ec7e3	IMAGE	1769409257101-634074275.jpg	10826111352882.jpg	image/jpeg	23190	/uploads/1769409257101-634074275.jpg	/uploads/thumb-1769409257101-634074275.jpg	\N	\N	\N	2026-01-26 06:34:17.117	2026-01-26 06:34:17.117
067dc292-9ced-43be-be6f-3f2ddc3d179e	IMAGE	1769409260491-942423281.jpg	19602JHKH.jpg	image/jpeg	816864	/uploads/1769409260491-942423281.jpg	/uploads/thumb-1769409260491-942423281.jpg	\N	\N	\N	2026-01-26 06:34:20.514	2026-01-26 06:34:20.514
d245d98d-c7a2-45bb-a01b-ff864569e31d	IMAGE	1769409495650-16554277.jpg	1655801016830.jpg	image/jpeg	712560	/uploads/1769409495650-16554277.jpg	/uploads/thumb-1769409495650-16554277.jpg	\N	\N	\N	2026-01-26 06:38:15.679	2026-01-26 06:38:15.679
b5a640d9-00f8-492f-a5c4-3ace4503cff1	IMAGE	1769410316088-264223652.jpg	1655801016830.jpg	image/jpeg	712560	/uploads/1769410316088-264223652.jpg	/uploads/thumb-1769410316088-264223652.jpg	\N	\N	\N	2026-01-26 06:51:56.11	2026-01-26 06:51:56.11
a69a5e99-962b-46c3-b9ff-333a6ed2f3d5	IMAGE	1769410344192-721385187.jpg	1655801016830.jpg	image/jpeg	712560	/uploads/1769410344192-721385187.jpg	/uploads/thumb-1769410344192-721385187.jpg	\N	\N	\N	2026-01-26 06:52:24.217	2026-01-26 06:52:24.217
ef693c73-ae9a-404d-8526-0cf8d7272d07	IMAGE	1769412394068-409944603.jpg	1655801016830.jpg	image/jpeg	712560	/uploads/1769412394068-409944603.jpg	/uploads/thumb-1769412394068-409944603.jpg	\N	\N	\N	2026-01-26 07:26:34.096	2026-01-26 07:26:34.096
de110b52-a8fc-4508-9bd5-8ba2acefedb2	IMAGE	1769412573702-315373838.png	260420677_904969586812042_1421742849448889402_n-Photoroom.png	image/png	320830	/uploads/1769412573702-315373838.png	/uploads/thumb-1769412573702-315373838.png	\N	\N	\N	2026-01-26 07:29:33.727	2026-01-26 07:29:33.727
977c5caa-6c89-4309-aabb-8e8e3f71fa86	IMAGE	1769412784339-601981755.jpg	10826111352882.jpg	image/jpeg	23190	/uploads/1769412784339-601981755.jpg	/uploads/thumb-1769412784339-601981755.jpg	\N	\N	\N	2026-01-26 07:33:04.367	2026-01-26 07:33:04.367
68ce3ebb-2cf9-45d8-80ba-49b07f182d62	IMAGE	1769412964226-677374941.jpg	260420677_904969586812042_1421742849448889402_n.jpg	image/jpeg	78538	/uploads/1769412964226-677374941.jpg	/uploads/thumb-1769412964226-677374941.jpg	\N	\N	\N	2026-01-26 07:36:04.237	2026-01-26 07:36:04.237
71748e70-de6e-4b70-9e74-37adb8483a76	IMAGE	1769412988131-355344823.jpg	1655801016830.jpg	image/jpeg	712560	/uploads/1769412988131-355344823.jpg	/uploads/thumb-1769412988131-355344823.jpg	\N	\N	\N	2026-01-26 07:36:28.155	2026-01-26 07:36:28.155
9a124bb0-3360-4926-8d7a-0d4e5c21b92d	IMAGE	1769413025065-473809428.jpg	1655801016830.jpg	image/jpeg	712560	/uploads/1769413025065-473809428.jpg	/uploads/thumb-1769413025065-473809428.jpg	\N	\N	\N	2026-01-26 07:37:05.088	2026-01-26 07:37:05.088
22e839e9-ed8d-40fd-87f7-d587b46a96d2	IMAGE	1769413455984-743372498.jpg	1655801016830.jpg	image/jpeg	712560	/uploads/1769413455984-743372498.jpg	/uploads/thumb-1769413455984-743372498.jpg	\N	\N	\N	2026-01-26 07:44:16.002	2026-01-26 07:44:16.002
a262e8a1-1017-4802-a8bc-e0e51900c697	IMAGE	1769414965060-483627030.jpg	1655801016830.jpg	image/jpeg	712560	/uploads/1769414965060-483627030.jpg	/uploads/thumb-1769414965060-483627030.jpg	\N	\N	\N	2026-01-26 08:09:25.085	2026-01-26 08:09:25.085
9c541158-93f8-4503-99ac-4b2771ab109e	IMAGE	1769415153123-689083399.jpg	260420677_904969586812042_1421742849448889402_n.jpg	image/jpeg	78538	/uploads/1769415153123-689083399.jpg	/uploads/thumb-1769415153123-689083399.jpg	\N	\N	\N	2026-01-26 08:12:33.137	2026-01-26 08:12:33.137
774665d4-8fa3-4d7f-a181-3419ed3d79c5	IMAGE	1769415387518-622629522.jpg	260420677_904969586812042_1421742849448889402_n.jpg	image/jpeg	78538	/uploads/1769415387518-622629522.jpg	/uploads/thumb-1769415387518-622629522.jpg	\N	\N	\N	2026-01-26 08:16:27.53	2026-01-26 08:16:27.53
\.


--
-- Data for Name: Menu; Type: TABLE DATA; Schema: public; Owner: hocalara_admin
--

COPY public."Menu" (id, name, slug, "position", "isActive", "createdById", "createdAt", "updatedAt") FROM stdin;
fede0d87-ba73-4b89-903f-41d98f67e619	Ana Menü	ana-menu	HEADER	t	dde31d5c-b9ef-4f4f-b4f9-95192ec3ea8a	2026-01-21 14:53:08.072	2026-01-21 14:53:08.072
\.


--
-- Data for Name: MenuItem; Type: TABLE DATA; Schema: public; Owner: hocalara_admin
--

COPY public."MenuItem" (id, "menuId", "parentId", label, url, "pageId", "categoryId", target, "order", "isActive", "seoTitle", "seoNoFollow", "createdAt", "updatedAt") FROM stdin;
\.


--
-- Data for Name: Notification; Type: TABLE DATA; Schema: public; Owner: hocalara_admin
--

COPY public."Notification" (id, type, title, message, "userId", "changeRequestId", "isRead", "createdAt", "updatedAt") FROM stdin;
942ab62f-08d5-42b6-9fdf-18b8acbbba7d	CHANGE_APPROVED	✅ Değişiklik Onaylandı	Yeni öğretmen ekleme talebiniz onaylandı ve yayınlandı.	aa5d5dba-0088-4074-950f-2f0336190f8b	2b462434-66cd-4dd0-97d3-18c0d3879f16	t	2026-01-23 17:20:26.069	2026-01-23 17:20:36.81
94cb6ede-95ca-4ff0-b967-9ee935bc1aba	CHANGE_APPROVED	✅ Değişiklik Onaylandı	Şube bilgisi güncelleme talebiniz onaylandı ve yayınlandı.	aa5d5dba-0088-4074-950f-2f0336190f8b	931488ce-685e-4bee-9344-b48ae907b73b	t	2026-01-23 17:20:22.248	2026-01-23 17:20:38.09
c6f96e60-3f71-4241-959e-87c11f0db693	CHANGE_APPROVED	✅ Değişiklik Onaylandı	Yeni öğretmen ekleme talebiniz onaylandı ve yayınlandı.	aa5d5dba-0088-4074-950f-2f0336190f8b	93ae9811-f90a-47b0-a73c-184f2a08806d	t	2026-01-23 17:19:11.878	2026-01-23 17:20:38.251
d0741080-f943-4ecb-80b6-a05aa840e10e	CHANGE_REJECTED	❌ Değişiklik Reddedildi	Şube bilgisi güncelleme talebiniz reddedildi.	aa5d5dba-0088-4074-950f-2f0336190f8b	3470031d-6244-4268-a0fe-461c25eaa98e	t	2026-01-23 17:19:07.222	2026-01-23 17:20:38.405
8e2be1a7-8190-44f9-ac54-940b7beb2aa3	CHANGE_APPROVED	✅ Değişiklik Onaylandı	Şube bilgisi güncelleme talebiniz onaylandı ve yayınlandı.	aa5d5dba-0088-4074-950f-2f0336190f8b	5c096a30-a5ed-4b53-8aff-f4ff7b75856d	t	2026-01-23 17:19:03.825	2026-01-23 17:20:38.541
122fd61f-2350-4596-a4be-7305f4bc36c9	CHANGE_APPROVED	✅ Değişiklik Onaylandı	Öğretmen silme talebiniz onaylandı ve yayınlandı.\n\nYönetici Notu: fghfh	aa5d5dba-0088-4074-950f-2f0336190f8b	94518a80-77fe-4c3f-a424-0981a5dd0a43	t	2026-01-23 16:56:46.528	2026-01-23 17:20:38.687
821cf112-7a14-48e5-965f-6c52c84619eb	CHANGE_APPROVED	✅ Değişiklik Onaylandı	Yeni öğretmen ekleme talebiniz onaylandı ve yayınlandı.	aa5d5dba-0088-4074-950f-2f0336190f8b	4d04f8c2-477c-4731-b43d-0e7d30fe7e36	t	2026-01-23 16:56:19.607	2026-01-23 17:20:38.832
15ba4f4b-77aa-4104-b8aa-b0d61d1f33dd	CHANGE_REJECTED	❌ Değişiklik Reddedildi	Öğretmen silme talebiniz reddedildi.	aa5d5dba-0088-4074-950f-2f0336190f8b	90bd9f18-5fd2-40ca-ad55-6a889451e5a1	t	2026-01-23 16:46:08.885	2026-01-23 17:20:38.965
68e185d2-69f3-41af-8857-33b57e677bcd	CHANGE_APPROVED	✅ Değişiklik Onaylandı	Öğretmen silme talebiniz onaylandı ve yayınlandı.	aa5d5dba-0088-4074-950f-2f0336190f8b	966573ac-c4dc-4b19-8ef0-45bcfd98c6ce	t	2026-01-23 16:45:59.278	2026-01-23 17:20:39.106
56f282d5-d167-4cec-b16d-b3fb9bd063a4	CHANGE_APPROVED	✅ Değişiklik Onaylandı	Öğretmen silme talebiniz onaylandı ve yayınlandı.	aa5d5dba-0088-4074-950f-2f0336190f8b	c65afe94-5051-4d38-b838-3005810f00ed	t	2026-01-23 16:45:54.08	2026-01-23 17:20:39.258
1708649f-9b9c-4e86-bb86-db6e22ee62c3	CHANGE_APPROVED	✅ Değişiklik Onaylandı	Şube bilgisi güncelleme talebiniz onaylandı ve yayınlandı.	aa5d5dba-0088-4074-950f-2f0336190f8b	6b1b56be-c414-4ad3-aabd-9d761ad57945	t	2026-01-23 16:45:48.916	2026-01-23 17:20:39.372
68b3e19f-6513-4fc6-98fe-6b22a92eb693	CHANGE_APPROVED	✅ Değişiklik Onaylandı	Yeni öğretmen ekleme talebiniz onaylandı ve yayınlandı.	aa5d5dba-0088-4074-950f-2f0336190f8b	d685e053-105c-4df3-8b33-8e2218bcc4b6	t	2026-01-23 16:41:47.752	2026-01-23 17:20:39.512
ac34bf0d-4b4a-4793-9ef5-35f8daa03f19	CHANGE_APPROVED	✅ Değişiklik Onaylandı	Yeni öğretmen ekleme talebiniz onaylandı ve yayınlandı.	aa5d5dba-0088-4074-950f-2f0336190f8b	7141bbc7-d445-498f-b1a3-b1be78f79523	t	2026-01-23 16:39:22.856	2026-01-23 17:20:39.641
d09e9b98-256a-4497-9e38-f658b12f39fc	CHANGE_APPROVED	✅ Değişiklik Onaylandı	Şube bilgisi güncelleme talebiniz onaylandı ve yayınlandı.	aa5d5dba-0088-4074-950f-2f0336190f8b	133d5dfd-84dd-4e88-b6c1-15640861d814	t	2026-01-23 16:38:44.617	2026-01-23 17:20:39.788
02444444-9736-45a7-b94d-21b8d4247a35	CHANGE_REJECTED	❌ Değişiklik Reddedildi	Şube bilgisi güncelleme talebiniz reddedildi.	aa5d5dba-0088-4074-950f-2f0336190f8b	e72edd3a-0a44-4966-b7ca-acbf65825937	t	2026-01-23 16:36:56.48	2026-01-23 17:20:39.91
20ccf0c9-42c6-4b13-8683-36b496f2c2ae	CHANGE_APPROVED	✅ Değişiklik Onaylandı	Şube bilgisi güncelleme talebiniz onaylandı ve yayınlandı.\n\nYönetici Notu: Test approval from script	aa5d5dba-0088-4074-950f-2f0336190f8b	eb608ee0-d172-4582-b1f2-f6c0d6313cba	t	2026-01-23 09:02:31.609	2026-01-23 17:20:40.044
615db600-8e43-4e65-9b23-23a2241cd582	CHANGE_APPROVED	✅ Değişiklik Onaylandı	Haber silme talebiniz onaylandı ve yayınlandı.	aa5d5dba-0088-4074-950f-2f0336190f8b	06fd9c9c-9ca3-4a37-ae46-bd029c1229a2	t	2026-01-24 11:01:05.083	2026-01-25 05:23:39.312
9e5cc606-2447-4eac-a62f-ca75729fc181	CHANGE_APPROVED	✅ Değişiklik Onaylandı	Haber silme talebiniz onaylandı ve yayınlandı.	aa5d5dba-0088-4074-950f-2f0336190f8b	cf84b169-6bc2-436a-9d17-cd37207f3186	t	2026-01-24 11:00:44.988	2026-01-25 05:23:39.474
d79acfa1-2fb8-47b8-a0d1-4f19b9930745	CHANGE_APPROVED	✅ Değişiklik Onaylandı	Yeni haber ekleme talebiniz onaylandı ve yayınlandı.	aa5d5dba-0088-4074-950f-2f0336190f8b	41de54d1-f5b2-4ea4-a0bd-516d3553c77e	t	2026-01-24 06:23:18.169	2026-01-25 05:23:39.65
2ed229f8-f1b9-4f93-8045-d59f96e29335	CHANGE_APPROVED	✅ Değişiklik Onaylandı	Yeni haber ekleme talebiniz onaylandı ve yayınlandı.	aa5d5dba-0088-4074-950f-2f0336190f8b	5036bafe-5cc0-4b5f-84e1-81c6bf9d73bc	t	2026-01-24 06:18:59.928	2026-01-25 05:23:39.792
6e22945e-16b6-4246-8e28-cc728e140d83	CHANGE_APPROVED	✅ Değişiklik Onaylandı	Yeni haber ekleme talebiniz onaylandı ve yayınlandı.\n\nYönetici Notu: dsfsds	aa5d5dba-0088-4074-950f-2f0336190f8b	309496c0-9563-4851-a59b-0151d0c17aab	t	2026-01-24 06:18:58.046	2026-01-25 05:23:39.931
410b17c5-2775-4422-87df-8a9dfc19a260	CHANGE_APPROVED	✅ Değişiklik Onaylandı	Yeni haber ekleme talebiniz onaylandı ve yayınlandı.	aa5d5dba-0088-4074-950f-2f0336190f8b	f16b25f6-04a3-4bec-abd6-8d365253bd26	t	2026-01-24 05:51:18.118	2026-01-25 05:23:40.371
9f9dc3f5-02eb-43f4-a329-967edd1a3d88	CHANGE_APPROVED	✅ Değişiklik Onaylandı	Yeni haber ekleme talebiniz onaylandı ve yayınlandı.	aa5d5dba-0088-4074-950f-2f0336190f8b	295590f8-9887-499c-8358-7ee6fd2253ab	t	2026-01-24 05:49:11.738	2026-01-25 05:23:40.546
277251f1-ed5f-48a7-b5fa-61109de5d8c3	CHANGE_APPROVED	✅ Değişiklik Onaylandı	Haber güncelleme talebiniz onaylandı ve yayınlandı.	aa5d5dba-0088-4074-950f-2f0336190f8b	da5333cf-f2be-434b-94c4-9fc88ca79f88	t	2026-01-24 05:45:46.198	2026-01-25 05:23:40.682
6dd878d4-3aa9-41d7-97e3-0cab31cd7a26	CHANGE_APPROVED	✅ Değişiklik Onaylandı	Yeni haber ekleme talebiniz onaylandı ve yayınlandı.	aa5d5dba-0088-4074-950f-2f0336190f8b	c6c1fdc3-bbf2-46c6-a234-7f9b6eb18b62	t	2026-01-24 05:31:51.137	2026-01-25 05:23:40.863
5c9c1ed3-a37b-4048-bd97-e2db89cb1ce8	CHANGE_APPROVED	✅ Değişiklik Onaylandı	Paket güncelleme talebiniz onaylandı ve yayınlandı.	aa5d5dba-0088-4074-950f-2f0336190f8b	b50cf60c-3646-4aba-9217-87b0383aab53	t	2026-01-23 19:42:19.637	2026-01-25 05:23:41.003
f50242cc-ee62-4b81-b117-48366ab3008e	CHANGE_APPROVED	✅ Değişiklik Onaylandı	Paket güncelleme talebiniz onaylandı ve yayınlandı.	aa5d5dba-0088-4074-950f-2f0336190f8b	847807cc-76e1-4832-8229-9adf5c989a02	t	2026-01-23 19:40:16.612	2026-01-25 05:23:41.162
e035f4fd-27f5-454d-923c-64411fbee89d	CHANGE_APPROVED	✅ Değişiklik Onaylandı	Paket güncelleme talebiniz onaylandı ve yayınlandı.	aa5d5dba-0088-4074-950f-2f0336190f8b	32af63bb-824d-4a53-b2ec-f3b981f1e719	t	2026-01-23 19:34:32.268	2026-01-25 05:23:41.309
44f4d831-12c8-4fa6-8a73-0eaad8f297fa	CHANGE_APPROVED	✅ Değişiklik Onaylandı	Paket güncelleme talebiniz onaylandı ve yayınlandı.	aa5d5dba-0088-4074-950f-2f0336190f8b	7a114e06-7f06-46d8-91d0-1e0f632f8b9b	t	2026-01-23 19:32:51.758	2026-01-25 05:23:41.462
a5ecb330-ed9e-4c62-8a33-513895b098b6	CHANGE_APPROVED	✅ Değişiklik Onaylandı	Yeni paket ekleme talebiniz onaylandı ve yayınlandı.	aa5d5dba-0088-4074-950f-2f0336190f8b	e7d6c8b6-981a-4ab2-a4cc-964ce7583dc8	t	2026-01-23 19:25:09.376	2026-01-25 05:23:41.613
1ec7dbf8-adee-47f5-bb72-44381dc259ab	CHANGE_PENDING	🔔 Yeni Başarı Ekleme Talebi	undefined yeni bir başarı ekleme talebi oluşturdu (2026).	dde31d5c-b9ef-4f4f-b4f9-95192ec3ea8a	b1654a6f-eec7-46b2-8e43-7da18f19698a	f	2026-01-24 11:43:04.403	2026-01-24 11:43:04.403
7fbe656c-099e-4f50-868f-004e165c9237	CHANGE_PENDING	🔔 Yeni Başarı Ekleme Talebi	undefined yeni bir başarı ekleme talebi oluşturdu (2026).	dde31d5c-b9ef-4f4f-b4f9-95192ec3ea8a	5faef013-5fb1-4484-93ab-06bfdbc55700	f	2026-01-24 11:53:05.11	2026-01-24 11:53:05.11
58a382cc-309e-4b59-85f9-86ad95a5944b	CHANGE_PENDING	🔔 Yeni Öğrenci Ekleme Talebi	undefined bir öğrenci ekleme talebi oluşturdu (sdfs).	dde31d5c-b9ef-4f4f-b4f9-95192ec3ea8a	a5d50129-4105-40db-9136-1c91a2ba8764	f	2026-01-24 12:44:43.416	2026-01-24 12:44:43.416
9cee3404-32d4-4286-8e6c-b2b735a84663	CHANGE_PENDING	🔔 Yeni Başarı Ekleme Talebi	undefined yeni bir başarı ekleme talebi oluşturdu (2025).	dde31d5c-b9ef-4f4f-b4f9-95192ec3ea8a	12cb1900-8d4b-4af1-aa4f-8ee247231fae	f	2026-01-24 12:50:02.418	2026-01-24 12:50:02.418
a60cb117-70a7-4a6a-b5b8-4877fb63a757	CHANGE_APPROVED	✅ Değişiklik Onaylandı	Yeni haber ekleme talebiniz onaylandı ve yayınlandı.	aa5d5dba-0088-4074-950f-2f0336190f8b	062013f5-ed5f-4849-a3c8-f22e93e9d5a5	t	2026-01-24 16:09:10.329	2026-01-25 05:23:37.826
1d0f41c0-6ec7-43a8-9d72-17ec51f5c6ae	CHANGE_APPROVED	✅ Değişiklik Onaylandı	Yeni başarı ekleme talebiniz onaylandı ve yayınlandı.	aa5d5dba-0088-4074-950f-2f0336190f8b	12cb1900-8d4b-4af1-aa4f-8ee247231fae	t	2026-01-24 12:50:12.82	2026-01-25 05:23:38.004
08fcabce-5427-46d3-bbb3-0b4545565174	CHANGE_APPROVED	✅ Değişiklik Onaylandı	Yeni öğrenci ekleme talebiniz onaylandı ve yayınlandı.	aa5d5dba-0088-4074-950f-2f0336190f8b	a5d50129-4105-40db-9136-1c91a2ba8764	t	2026-01-24 12:46:27.781	2026-01-25 05:23:38.204
b0762c3f-aef5-4fc6-ae4e-934aa8efffee	CHANGE_REJECTED	❌ Değişiklik Reddedildi	Yeni başarı ekleme talebiniz reddedildi.	aa5d5dba-0088-4074-950f-2f0336190f8b	5faef013-5fb1-4484-93ab-06bfdbc55700	t	2026-01-24 12:01:04.716	2026-01-25 05:23:38.667
c7a02527-1659-4c7f-bacb-3f0b917aeb9a	CHANGE_APPROVED	✅ Değişiklik Onaylandı	Yeni başarı ekleme talebiniz onaylandı ve yayınlandı.	aa5d5dba-0088-4074-950f-2f0336190f8b	b1654a6f-eec7-46b2-8e43-7da18f19698a	t	2026-01-24 11:47:39.928	2026-01-25 05:23:38.848
cc9db1b2-4f62-405f-934f-9b32ab643f68	CHANGE_APPROVED	✅ Değişiklik Onaylandı	Yeni haber ekleme talebiniz onaylandı ve yayınlandı.	aa5d5dba-0088-4074-950f-2f0336190f8b	2837daf8-047c-4cb1-bbea-8e835e4ce017	t	2026-01-24 11:23:23.887	2026-01-25 05:23:39.141
6b113f26-0a18-4078-aaa1-82aa4ec51208	CHANGE_PENDING	🔔 Yeni Öğrenci Ekleme Talebi	undefined bir öğrenci ekleme talebi oluşturdu (ferit).	dde31d5c-b9ef-4f4f-b4f9-95192ec3ea8a	2076557f-d2e2-4245-96be-6e7bdf98d015	f	2026-01-26 06:08:50.18	2026-01-26 06:08:50.18
c1180a0d-068e-4ff5-b2c6-6696355f5f76	CHANGE_APPROVED	✅ Değişiklik Onaylandı	Şube bilgisi güncelleme talebiniz onaylandı ve yayınlandı.	aa5d5dba-0088-4074-950f-2f0336190f8b	e11cf7d6-1603-41b8-af00-1136f562d519	f	2026-01-26 06:09:09.497	2026-01-26 06:09:09.497
42819b1a-0aea-4efb-9051-5acf181c6204	CHANGE_APPROVED	✅ Değişiklik Onaylandı	Yeni öğrenci ekleme talebiniz onaylandı ve yayınlandı.	aa5d5dba-0088-4074-950f-2f0336190f8b	2076557f-d2e2-4245-96be-6e7bdf98d015	f	2026-01-26 06:09:12.886	2026-01-26 06:09:12.886
0f6a200f-b96c-4b29-b1c7-39a6599f802f	CHANGE_APPROVED	✅ Değişiklik Onaylandı	Öğretmen silme talebiniz onaylandı ve yayınlandı.	aa5d5dba-0088-4074-950f-2f0336190f8b	9381d57e-06cb-4a21-aaff-6ca09ad7bdfb	f	2026-01-26 06:09:16.011	2026-01-26 06:09:16.011
13049baa-a91a-4cdc-9c80-302aed94822a	CHANGE_APPROVED	✅ Değişiklik Onaylandı	Öğretmen silme talebiniz onaylandı ve yayınlandı.	aa5d5dba-0088-4074-950f-2f0336190f8b	15f3cf56-0759-4fdd-8d90-d2465c8505e9	f	2026-01-26 06:09:18.814	2026-01-26 06:09:18.814
fed06aa9-3599-41eb-80c6-7fadf076734a	CHANGE_APPROVED	✅ Değişiklik Onaylandı	Şube bilgisi güncelleme talebiniz onaylandı ve yayınlandı.	aa5d5dba-0088-4074-950f-2f0336190f8b	87391066-9fbe-44da-b211-440d3b3697bd	f	2026-01-26 06:09:33.257	2026-01-26 06:09:33.257
e11a0057-5e9f-4ab5-b1cc-3e3670d053a5	CHANGE_APPROVED	✅ Değişiklik Onaylandı	Şube bilgisi güncelleme talebiniz onaylandı ve yayınlandı.	aa5d5dba-0088-4074-950f-2f0336190f8b	2b2f41b1-ed96-4f43-b69b-dcdf279717d2	f	2026-01-26 06:09:44.704	2026-01-26 06:09:44.704
d9753ebe-1a2f-4615-87e3-f89a756fa2d0	CHANGE_APPROVED	✅ Değişiklik Onaylandı	Şube bilgisi güncelleme talebiniz onaylandı ve yayınlandı.	aa5d5dba-0088-4074-950f-2f0336190f8b	b7288b5f-d8f3-436c-955a-a0d6cbf98fef	f	2026-01-26 06:10:09.463	2026-01-26 06:10:09.463
edd87a2a-0d09-4058-944c-4207283b9d35	CHANGE_APPROVED	✅ Değişiklik Onaylandı	Şube bilgisi güncelleme talebiniz onaylandı ve yayınlandı.	aa5d5dba-0088-4074-950f-2f0336190f8b	788699df-a62d-4802-827f-ec4c5f4f72dc	f	2026-01-26 06:13:56.742	2026-01-26 06:13:56.742
307d33a7-e6d6-4975-b79d-f32484781403	CHANGE_REJECTED	❌ Değişiklik Reddedildi	Şube bilgisi güncelleme talebiniz reddedildi.	aa5d5dba-0088-4074-950f-2f0336190f8b	5a8c2eca-0aa5-45df-abd6-03cd7dad9f55	f	2026-01-26 06:16:23.964	2026-01-26 06:16:23.964
b52ea01c-0ff5-48f7-839c-fc6c2ddcbf5c	CHANGE_APPROVED	✅ Değişiklik Onaylandı	Şube bilgisi güncelleme talebiniz onaylandı ve yayınlandı.	aa5d5dba-0088-4074-950f-2f0336190f8b	70f6eab3-a2c9-43ee-bc5a-184b192568dc	f	2026-01-26 06:21:43.044	2026-01-26 06:21:43.044
50c1fe73-5356-4a32-8dad-2a3200e22b71	CHANGE_APPROVED	✅ Değişiklik Onaylandı	Şube bilgisi güncelleme talebiniz onaylandı ve yayınlandı.	aa5d5dba-0088-4074-950f-2f0336190f8b	f0f39356-4beb-4cd6-ab2d-37ef2d4f21a2	f	2026-01-26 06:23:52.976	2026-01-26 06:23:52.976
c233b911-e2b6-4a78-864e-d64999e9f031	CHANGE_APPROVED	✅ Değişiklik Onaylandı	Şube bilgisi güncelleme talebiniz onaylandı ve yayınlandı.	aa5d5dba-0088-4074-950f-2f0336190f8b	5e9906ff-e31b-4358-9f39-d759ce5033ce	f	2026-01-26 06:24:07.74	2026-01-26 06:24:07.74
747d983d-8117-4d2b-92e5-df925773ee78	CHANGE_APPROVED	✅ Değişiklik Onaylandı	Şube bilgisi güncelleme talebiniz onaylandı ve yayınlandı.	aa5d5dba-0088-4074-950f-2f0336190f8b	637dfd13-7133-42bd-88cb-361982989b37	f	2026-01-26 06:30:43.894	2026-01-26 06:30:43.894
b2d21a79-03de-47b1-9e10-4505e4ea866a	CHANGE_APPROVED	✅ Değişiklik Onaylandı	Şube bilgisi güncelleme talebiniz onaylandı ve yayınlandı.	aa5d5dba-0088-4074-950f-2f0336190f8b	2455c46c-caad-484d-805b-3cce7ecbc84d	f	2026-01-26 06:32:10.565	2026-01-26 06:32:10.565
7c4d605d-283d-426c-a747-1aebbcc33596	CHANGE_APPROVED	✅ Değişiklik Onaylandı	Yeni paket ekleme talebiniz onaylandı ve yayınlandı.	aa5d5dba-0088-4074-950f-2f0336190f8b	8b9a16eb-595c-4e5a-a2bd-c0745a3d8c74	f	2026-01-26 06:34:28.982	2026-01-26 06:34:28.982
e899c0ae-84db-4629-853d-e2cc36f04b6a	CHANGE_APPROVED	✅ Değişiklik Onaylandı	Yeni paket ekleme talebiniz onaylandı ve yayınlandı.	aa5d5dba-0088-4074-950f-2f0336190f8b	108fd2a2-8161-438f-a7eb-ad501a01ed85	f	2026-01-26 06:47:22.368	2026-01-26 06:47:22.368
099228ed-a709-46c3-8a8c-68b77b02a0df	CHANGE_APPROVED	✅ Değişiklik Onaylandı	Yeni paket ekleme talebiniz onaylandı ve yayınlandı.	aa5d5dba-0088-4074-950f-2f0336190f8b	7ebdfc5e-9049-4a13-8684-f86138ea73d6	f	2026-01-26 06:52:32.954	2026-01-26 06:52:32.954
ff1cd958-a495-4288-b013-19e5eaa6973d	CHANGE_APPROVED	✅ Değişiklik Onaylandı	Yeni haber ekleme talebiniz onaylandı ve yayınlandı.	aa5d5dba-0088-4074-950f-2f0336190f8b	d658b75e-e964-48a9-8bd9-11e34bf4f26e	f	2026-01-26 07:36:57.309	2026-01-26 07:36:57.309
ff090c3d-67ed-435e-aba2-384f07050e67	CHANGE_APPROVED	✅ Değişiklik Onaylandı	Yeni haber ekleme talebiniz onaylandı ve yayınlandı.	aa5d5dba-0088-4074-950f-2f0336190f8b	ef5fbbf4-6c09-4cd5-822e-e997a156c261	f	2026-01-26 07:38:30.134	2026-01-26 07:38:30.134
4e150bed-2488-41ef-98d0-c51e55afb57f	CHANGE_APPROVED	✅ Değişiklik Onaylandı	Paket silme talebiniz onaylandı ve yayınlandı.	aa5d5dba-0088-4074-950f-2f0336190f8b	660a85d1-6e3b-4804-ba85-a6b5e2c3f6a3	f	2026-01-26 07:43:58.412	2026-01-26 07:43:58.412
f3394fa9-036e-4f51-80ff-51250c85feed	CHANGE_APPROVED	✅ Değişiklik Onaylandı	Paket silme talebiniz onaylandı ve yayınlandı.	aa5d5dba-0088-4074-950f-2f0336190f8b	3a56ae37-e1f1-4e36-9ed2-334e0774beb6	f	2026-01-26 07:43:59.76	2026-01-26 07:43:59.76
c406092b-32b0-476d-9790-95eee0bbce20	CHANGE_REJECTED	❌ Değişiklik Reddedildi	Paket silme talebiniz reddedildi.	aa5d5dba-0088-4074-950f-2f0336190f8b	47ef24e0-1a2b-42a6-b457-8ff3bf7d0cd7	f	2026-01-26 07:54:54.955	2026-01-26 07:54:54.955
f20dd940-3dcd-4af6-988a-9edc7d3561a1	CHANGE_APPROVED	✅ Değişiklik Onaylandı	Yeni paket ekleme talebiniz onaylandı ve yayınlandı.	aa5d5dba-0088-4074-950f-2f0336190f8b	1e448301-c66b-46e5-bf56-30788b9cbc39	f	2026-01-26 07:55:06.248	2026-01-26 07:55:06.248
4540f29a-c3e5-43f6-9114-a8b2de146918	CHANGE_PENDING	🔔 Başarı Silme Talebi	undefined bir başarı silme talebi oluşturdu (2025).	dde31d5c-b9ef-4f4f-b4f9-95192ec3ea8a	ba4a95a8-86c5-4a8e-98ef-bb2ac0781940	f	2026-01-26 08:08:37.493	2026-01-26 08:08:37.493
21269e4d-2283-4501-bf23-8926008b905f	CHANGE_APPROVED	✅ Değişiklik Onaylandı	Başarı silme talebiniz onaylandı ve yayınlandı.	aa5d5dba-0088-4074-950f-2f0336190f8b	ba4a95a8-86c5-4a8e-98ef-bb2ac0781940	f	2026-01-26 08:08:45.103	2026-01-26 08:08:45.103
15de04a8-30cd-4a9d-8c24-c1f146b9e105	CHANGE_PENDING	🔔 Yeni Başarı Ekleme Talebi	undefined yeni bir başarı ekleme talebi oluşturdu (2025).	dde31d5c-b9ef-4f4f-b4f9-95192ec3ea8a	cd09e1b9-9f8e-425c-811d-8a2ea30f62d8	f	2026-01-26 08:09:26.192	2026-01-26 08:09:26.192
24d2854a-2ac0-43f6-a342-a84c9a25a424	CHANGE_REJECTED	❌ Değişiklik Reddedildi	Yeni başarı ekleme talebiniz reddedildi.	aa5d5dba-0088-4074-950f-2f0336190f8b	cd09e1b9-9f8e-425c-811d-8a2ea30f62d8	f	2026-01-26 08:12:10.363	2026-01-26 08:12:10.363
6b35a058-8f9f-4b72-9858-6cc2dd33fd15	CHANGE_PENDING	🔔 Yeni Başarı Ekleme Talebi	undefined yeni bir başarı ekleme talebi oluşturdu (2025).	dde31d5c-b9ef-4f4f-b4f9-95192ec3ea8a	75f272e0-cbb4-4edb-be6f-b7dddefa752e	f	2026-01-26 08:12:34.156	2026-01-26 08:12:34.156
6a69d240-51f1-41d2-9769-4db4bfafdef2	CHANGE_APPROVED	✅ Değişiklik Onaylandı	Yeni başarı ekleme talebiniz onaylandı ve yayınlandı.	aa5d5dba-0088-4074-950f-2f0336190f8b	75f272e0-cbb4-4edb-be6f-b7dddefa752e	f	2026-01-26 08:15:18.791	2026-01-26 08:15:18.791
540eeab0-d11f-4a8d-a6da-858a395c3a7c	CHANGE_PENDING	🔔 Başarı Güncelleme Talebi	undefined bir başarı güncelleme talebi oluşturdu (2025).	dde31d5c-b9ef-4f4f-b4f9-95192ec3ea8a	9e2d41f7-f979-4e7a-bab0-ea3b6e1c450d	f	2026-01-26 08:15:54.841	2026-01-26 08:15:54.841
b6258a40-b896-468b-8901-659cbee52c75	CHANGE_APPROVED	✅ Değişiklik Onaylandı	Başarı güncelleme talebiniz onaylandı ve yayınlandı.	aa5d5dba-0088-4074-950f-2f0336190f8b	9e2d41f7-f979-4e7a-bab0-ea3b6e1c450d	f	2026-01-26 08:15:59.179	2026-01-26 08:15:59.179
d3395541-ef7b-483f-b10d-4fa927913ad9	CHANGE_PENDING	🔔 Yeni Öğrenci Ekleme Talebi	undefined bir öğrenci ekleme talebi oluşturdu (ASD).	dde31d5c-b9ef-4f4f-b4f9-95192ec3ea8a	1259883f-489b-443d-970b-a2784352b3c7	f	2026-01-26 08:16:27.651	2026-01-26 08:16:27.651
64fd7af2-c863-4a50-a7ab-8029beaf524f	CHANGE_APPROVED	✅ Değişiklik Onaylandı	Yeni öğrenci ekleme talebiniz onaylandı ve yayınlandı.	aa5d5dba-0088-4074-950f-2f0336190f8b	1259883f-489b-443d-970b-a2784352b3c7	f	2026-01-26 08:16:32.932	2026-01-26 08:16:32.932
\.


--
-- Data for Name: Page; Type: TABLE DATA; Schema: public; Owner: hocalara_admin
--

COPY public."Page" (id, type, status, title, slug, content, excerpt, "featuredImage", "categoryId", "authorId", "branchId", "isApproved", "isFeatured", "publishedAt", "seoTitle", "seoDescription", "seoKeywords", "createdAt", "updatedAt") FROM stdin;
9897dd46-6780-49c2-9310-c7093887a494	NEWS	PUBLISHED	sdf	sd	sdf	sdffds	/uploads/1769100074273-627295304.jpg	d3c5a16f-9224-48d7-badf-83944e938d1f	dde31d5c-b9ef-4f4f-b4f9-95192ec3ea8a	64a6057c-6f39-427f-9b66-40719fe43014	f	f	2026-01-22 16:41:07.104	dsfs	sdf	sdfdsf	2026-01-22 16:41:07.105	2026-01-22 16:41:14.592
d8b3c020-ebce-4c53-a1bd-6ed6d80b3f44	NEWS	PUBLISHED	dfg	dfg	gdfgdg	dgdfgd	/uploads/1769148813566-962382040.jpg	d3c5a16f-9224-48d7-badf-83944e938d1f	dde31d5c-b9ef-4f4f-b4f9-95192ec3ea8a	64a6057c-6f39-427f-9b66-40719fe43014	f	t	2026-01-23 06:13:48.315	dfgd	dfg	dfgdg	2026-01-23 06:13:40.742	2026-01-23 06:13:48.316
f6b58cca-4ba4-4923-8c37-aa4c7db9f72c	NEWS	PUBLISHED	dfgdfg	dfgd	gdfgdgd	dfgd	/uploads/1769148868081-512705028.jpg	d3c5a16f-9224-48d7-badf-83944e938d1f	dde31d5c-b9ef-4f4f-b4f9-95192ec3ea8a	64a6057c-6f39-427f-9b66-40719fe43014	f	t	2026-01-23 06:14:34.622	d	fgd	dfg	2026-01-23 06:14:34.623	2026-01-23 06:14:34.623
b4beeb55-e455-479d-9d9c-336b6701cd07	NEWS	PUBLISHED	erdf	gdfgd	sdfsfs	dfgfdg	/uploads/1769250629753-877002079.png	d3c5a16f-9224-48d7-badf-83944e938d1f	dde31d5c-b9ef-4f4f-b4f9-95192ec3ea8a	64a6057c-6f39-427f-9b66-40719fe43014	f	t	2026-01-24 10:30:11.304	sdf	sdfsfsds	sdfsd	2026-01-24 10:30:06.089	2026-01-24 10:30:31.811
b5c92dda-a29f-4b2e-8d9e-785bde5d4ea5	NEWS	PUBLISHED	sdf	ssf	sdfdsfs	sdfsf	/uploads/1769250646334-739812208.png	d3c5a16f-9224-48d7-badf-83944e938d1f	dde31d5c-b9ef-4f4f-b4f9-95192ec3ea8a	\N	t	t	2026-01-24 10:30:54.327	sdf	fssd	sdfsdfs	2026-01-24 10:30:54.328	2026-01-24 10:30:54.328
5416513e-d11e-4a77-b1df-62eb103b9a89	NEWS	PUBLISHED	asda	dasdad	asdasdsad	asdad	\N	d3c5a16f-9224-48d7-badf-83944e938d1f	dde31d5c-b9ef-4f4f-b4f9-95192ec3ea8a	\N	t	f	2026-01-24 11:05:06.448	\N	\N	\N	2026-01-24 11:05:06.449	2026-01-24 11:05:06.449
895e7456-7033-4fc7-b4a0-2721fc09feeb	NEWS	PUBLISHED	gdfgfd	dfgdfgdgdg	fdgdgd	dfgg	\N	d3c5a16f-9224-48d7-badf-83944e938d1f	dde31d5c-b9ef-4f4f-b4f9-95192ec3ea8a	32904ae0-344e-447d-9e82-04add0acd926	f	f	2026-01-24 11:08:26.339	asd	asda	asdadsa	2026-01-24 11:08:26.339	2026-01-24 11:08:40.893
\.


--
-- Data for Name: Setting; Type: TABLE DATA; Schema: public; Owner: hocalara_admin
--

COPY public."Setting" (id, key, value, type, "group", "createdAt", "updatedAt") FROM stdin;
426e9783-f9f8-4b75-9cef-a0ede175bfda	site_name	Hocalara Geldik	string	general	2026-01-21 14:53:08.077	2026-01-21 14:53:08.077
ba3998bf-656b-4af7-b982-fd9e672c7b09	site_tagline	Türkiye'nin En Büyük Eğitim Ağı	string	general	2026-01-21 14:53:08.08	2026-01-21 14:53:08.08
723a0533-4ba2-43f9-abc2-e561af5f4ed1	contact_phone	0212 XXX XX XX	string	contact	2026-01-21 14:53:08.081	2026-01-21 14:53:08.081
b3f5af84-04eb-47ce-b735-73179bc29697	contact_email	info@hocalarageldik.com	string	contact	2026-01-21 14:53:08.083	2026-01-21 14:53:08.083
ff8e0496-7f38-4efb-84d1-faf94165ca84	social_facebook	https://facebook.com/hocalarageldik	string	social	2026-01-21 14:53:08.085	2026-01-21 14:53:08.085
00579484-8d8c-451f-be67-8c59e4214caa	social_instagram	https://instagram.com/hocalarageldik	string	social	2026-01-21 14:53:08.086	2026-01-21 14:53:08.086
8b23205f-7e5b-4d58-a573-a55ebb29a758	social_twitter	https://twitter.com/hocalarageldik	string	social	2026-01-21 14:53:08.087	2026-01-21 14:53:08.087
\.


--
-- Data for Name: Slider; Type: TABLE DATA; Schema: public; Owner: hocalara_admin
--

COPY public."Slider" (id, title, subtitle, image, link, target, "order", "isActive", "createdById", "createdAt", "updatedAt", "primaryButtonLink", "primaryButtonText", "secondaryButtonLink", "secondaryButtonText") FROM stdin;
d38e9b42-8e1b-49ba-9dbd-b21bc8b12f20	Hocalara geldik	hoşgelidiniz	/uploads/1769019604628-552406033.jpeg	\N	main	2	t	dde31d5c-b9ef-4f4f-b4f9-95192ec3ea8a	2026-01-21 18:20:04.693	2026-01-21 18:20:04.693	/hakkimizda	Hemen egitime başla	/franchise	Yeni sube ol
\.


--
-- Data for Name: SocialMedia; Type: TABLE DATA; Schema: public; Owner: hocalara_admin
--

COPY public."SocialMedia" (id, platform, url, "order", "isActive", "createdAt", "updatedAt") FROM stdin;
748ca9ff-27db-4f77-aec5-d76ca8d3b08c	youtube	https://www.youtube.com/watch?v=LlJO59c5mUM	0	t	2026-01-25 05:28:44.209	2026-01-25 05:28:44.209
\.


--
-- Data for Name: Statistic; Type: TABLE DATA; Schema: public; Owner: hocalara_admin
--

COPY public."Statistic" (id, value, label, icon, "order", "isActive", "createdAt", "updatedAt") FROM stdin;
ea4ffdc7-7896-4194-800d-aab703e7c1c2	81	İl	🏛️	1	t	2026-01-21 18:41:46.644	2026-01-21 18:41:46.644
7397bed0-3402-4be1-bd3f-ba76166138e4	250+	Şube	🏫	2	t	2026-01-21 18:41:46.658	2026-01-21 18:41:46.658
09aa2e25-aef7-4152-b7aa-538b296ef071	1500+	Öğretmen	👨‍🏫	3	t	2026-01-21 18:41:46.66	2026-01-21 18:41:46.66
2bc6877f-9419-48a6-a2a0-1364f18a8e85	50K+	Öğrenci	🎓	4	t	2026-01-21 18:41:46.662	2026-01-21 18:41:46.662
\.


--
-- Data for Name: SuccessBanner; Type: TABLE DATA; Schema: public; Owner: hocalara_admin
--

COPY public."SuccessBanner" (id, "yearlySuccessId", title, subtitle, description, image, "highlightText", "gradientFrom", "gradientTo") FROM stdin;
85db9141-54ae-4727-b0c3-f35d8f13df26	49d8ee65-e01e-40ff-8e24-eff0b51f4d78	2024 Yılı Başarılarımız	Türkiye Genelinde Rekor Başarı	2024 yılında öğrencilerimiz YKS ve LGS sınavlarında büyük başarılar elde etti. 156 derece, 1247 yerleşme ve %94.5 başarı oranı ile gurur duyuyoruz.	https://images.unsplash.com/photo-1523050854058-8df90110c9f1?w=1920	Türkiye Genelinde 156 Derece	#2563eb	#1e40af
d44dfd67-ca80-4a91-9bcb-1821717cc0d5	ba0cc1eb-252c-4226-adea-14896ababe08	2023 Yılı Başarılarımız	Sürekli Artan Başarı Grafiği	2023 yılında öğrencilerimiz 142 derece ile Türkiye genelinde adından söz ettirdi. 38 ilde 1156 öğrencimiz hedeflerine ulaştı.	https://images.unsplash.com/photo-1523240795612-9a054b0db644?w=1920	142 Derece ile Rekor Yıl	#7c3aed	#5b21b6
fd3042d5-cd78-4a8d-be11-e18b0a0b9f44	a7b7e28a-6360-4262-a722-527072b6db6d	2022 Yılı Başarılarımız	Güçlü Temeller, Parlak Gelecek	2022 yılında 128 derece ile öğrencilerimiz hayallerindeki üniversitelere yerleşti. 35 ilde 1089 başarı hikayesi yazdık.	https://images.unsplash.com/photo-1517486808906-6ca8b3f04846?w=1920	128 Derece ile Başarı	#059669	#047857
e0cae2ab-267b-4c4d-8ca5-1f3743861a7e	c1c9f768-738f-4e65-933f-09c20b805d2b	BÜYÜK BAŞARI	BÜYÜK BAŞARI	BÜYÜK BAŞARI	/uploads/1769093909411-158002793.jpeg	\N	#2563eb	#1e40af
2ed19365-b73c-4c89-904d-118904cf5694	3fa03375-ecac-4b2a-ba6e-e767dcb90388	sfdsf	fdsfs		/uploads/1769254937364-448045755.jpg	\N	#2563eb	#1e40af
11c74dfd-345c-4081-a1e4-e06dbb84ca3b	b1a9d3be-91f0-40d2-86c2-d46b625244fd	ASDSA	ASADAD		/uploads/1769415153123-689083399.jpg	\N	#2563eb	#1e40af
\.


--
-- Data for Name: Teacher; Type: TABLE DATA; Schema: public; Owner: hocalara_admin
--

COPY public."Teacher" (id, name, subject, image, "branchId", "isActive", "order", "createdAt", "updatedAt") FROM stdin;
20b64489-f37b-431e-a919-ead775e89534	ahmet	asda	/uploads/1769156500975-113166778.jpg	38aeca3e-8805-44e8-a87f-d87acabc0033	t	0	2026-01-23 08:21:41.998	2026-01-23 08:21:41.998
\.


--
-- Data for Name: TopStudent; Type: TABLE DATA; Schema: public; Owner: hocalara_admin
--

COPY public."TopStudent" (id, "yearlySuccessId", name, rank, exam, image, branch, university, score, "order") FROM stdin;
2c3cea21-7b66-4766-a525-c4754c234e93	49d8ee65-e01e-40ff-8e24-eff0b51f4d78	Ahmet Yılmaz	1	TYT	https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?w=400	İstanbul Kadıköy	İTÜ Bilgisayar Mühendisliği	548.5	0
91d5f9a8-cff7-451e-8f14-5a4e708983fd	49d8ee65-e01e-40ff-8e24-eff0b51f4d78	Ayşe Demir	3	AYT	https://images.unsplash.com/photo-1494790108377-be9c29b29330?w=400	Ankara Çankaya	ODTÜ Tıp Fakültesi	542.8	1
ba9df6b6-c7d7-4656-a2cd-bd015626dcbe	49d8ee65-e01e-40ff-8e24-eff0b51f4d78	Mehmet Kaya	5	LGS	https://images.unsplash.com/photo-1500648767791-00dcc994a43e?w=400	İzmir Karşıyaka	Fen Lisesi	498.2	2
7b54f65a-0174-4feb-96e0-d0f0736aa3ad	ba0cc1eb-252c-4226-adea-14896ababe08	Zeynep Şahin	2	TYT	https://images.unsplash.com/photo-1438761681033-6461ffad8d80?w=400	Bursa Nilüfer	Boğaziçi Üniversitesi	545.2	0
067a67a0-82c8-4c47-bb37-e4092cb2d938	ba0cc1eb-252c-4226-adea-14896ababe08	Can Öztürk	7	AYT	https://images.unsplash.com/photo-1472099645785-5658abf4ff4e?w=400	Antalya Muratpaşa	Hacettepe Tıp	538.9	1
b416e4ed-eec2-4116-bc03-e58fb58b69bf	a7b7e28a-6360-4262-a722-527072b6db6d	Elif Yıldız	4	LGS	https://images.unsplash.com/photo-1544005313-94ddf0286df2?w=400	İstanbul Üsküdar	Anadolu Lisesi	495.7	0
276d2aa7-69a9-43c6-a2a9-0bbb46989626	c1c9f768-738f-4e65-933f-09c20b805d2b				\N	\N	\N	\N	0
f2e918c2-651d-4855-807b-feabac8622cf	c1c9f768-738f-4e65-933f-09c20b805d2b	sdfsfs	123	sdfdsfsf	/uploads/1769095385612-463157235.jpeg	İstanbul Kadıköy	sdfds	123	0
6c55ae28-3f47-4385-a909-5c98ff03c52c	c1c9f768-738f-4e65-933f-09c20b805d2b	ASDA	123	YKS	/uploads/1769146576789-528896604.jpg	İstanbul Kadıköy	ASDAD	123	0
7a274c3d-7700-4ca5-8e8a-904e209a4eb9	3fa03375-ecac-4b2a-ba6e-e767dcb90388	ahmet	123	YKS	/uploads/1769256197441-393236010.jpg	BİLGİ	BUREDUR	1233	0
a977f31e-1330-41d8-b924-e46a1e902453	3fa03375-ecac-4b2a-ba6e-e767dcb90388	sdfs	123	YKS	/uploads/1769258683025-81945106.jpg	BİLGİ	ASDAAD	12333	1
bb0cd78f-f8c0-4069-9194-23d115750dd7	3fa03375-ecac-4b2a-ba6e-e767dcb90388	ferit	32	YKS	/uploads/1769407729709-784261839.jpg	BİLGİ	BAOGAZ	452	2
13b8277d-62b7-43c1-bca3-3651dbd0bd0a	b1a9d3be-91f0-40d2-86c2-d46b625244fd	ASD	12	YKS	/uploads/1769415387518-622629522.jpg	BİLGİ	BOGAZ	123	0
\.


--
-- Data for Name: User; Type: TABLE DATA; Schema: public; Owner: hocalara_admin
--

COPY public."User" (id, email, password, name, role, avatar, "isActive", "branchId", "createdAt", "updatedAt", "lastLoginAt") FROM stdin;
81891ccb-ef6e-4d19-a150-b2ed08d69838	kadikoy@hocalarageldik.com	$2a$10$muNGH7iRcK.544qicUJ8Mex8DuZqm8fYt4fYON.1A7Om1uckKFb1q	Kadıköy Yöneticisi	BRANCH_ADMIN	\N	t	32904ae0-344e-447d-9e82-04add0acd926	2026-01-21 14:53:08.069	2026-01-21 14:53:08.069	\N
dde31d5c-b9ef-4f4f-b4f9-95192ec3ea8a	admin@hocalarageldik.com	$2a$10$muNGH7iRcK.544qicUJ8Mex8DuZqm8fYt4fYON.1A7Om1uckKFb1q	Super Admin	SUPER_ADMIN	\N	t	\N	2026-01-21 14:53:08.06	2026-01-26 06:03:18.241	2026-01-26 06:03:18.24
036adf58-c72a-4549-8847-d0bb4ccc2c53	balçova@hg.com	$2a$10$x3bEf8bA2mcPA3nqBMKbfeKHQRTA4J6BvXKeYkmeYl6BsTP5wGkou	ahmett	BRANCH_ADMIN	\N	t	\N	2026-01-23 06:32:35.841	2026-01-23 06:32:35.841	\N
aa5d5dba-0088-4074-950f-2f0336190f8b	sube@urla.com	$2a$10$eZTFU6mhVTG68FBxVD11Cudd58sze74JCQ2ATNJ///JKLcUssEnCe	ahmet	BRANCH_ADMIN	\N	t	38aeca3e-8805-44e8-a87f-d87acabc0033	2026-01-23 06:36:47.483	2026-01-26 06:07:55.108	2026-01-26 06:07:55.107
\.


--
-- Data for Name: VideoLesson; Type: TABLE DATA; Schema: public; Owner: hocalara_admin
--

COPY public."VideoLesson" (id, title, description, thumbnail, "videoUrl", category, subject, duration, views, "uploadDate", teacher, difficulty, "isActive", "order", "createdAt", "updatedAt") FROM stdin;
8df194e7-3d35-42ba-bebe-c8d82058fc40	asdasad	sdfsf	https://img.youtube.com/vi/6VF6B6-WhHU/maxresdefault.jpg	https://www.youtube.com/watch?v=6VF6B6-WhHU	LGS	adssa	123	0	2026-01-23 05:58:00.314	sdfs	\N	t	0	2026-01-23 05:58:00.314	2026-01-23 05:58:00.314
c67d1c0c-4b47-43d1-9558-4cee5b94f83e	asdasd	asd	https://img.youtube.com/vi/6VF6B6-WhHU/maxresdefault.jpg	https://www.youtube.com/watch?v=6VF6B6-WhHU	YKS_AYT	asd	123	0	2026-01-23 06:04:18.8	zsdasd	\N	t	0	2026-01-23 06:04:18.8	2026-01-23 06:04:18.8
181c1c69-15c1-4cb4-b6e1-5236946b022b	24 KILLS + 2600 DAMAGE M416 MADNESS! (PUBG) 24 KILLS + 2600 DAMAGE M416 MADNESS! (PUBG)	\n531.805 görüntüleme  15 Eyl 2025\nMain Channel: @TGLTN\nCreator Code: TGLTN ► https://accounts.krafton.com/creator-...\n\nWatch me LIVE on Twitch ►   / tgltn  \nTikTok ►   / tgltnpubg  \nTwitter ►   / tgltnpubg  \nInstagram ►   / tgltnpubg  \nDiscord ►   / discord  \n\nVideo Editor:   / acep1re  \nThumbnail:   / iamrahul_dhiman  \n\n0:00 Use Creator Code TGLTN\n22:47 End\n	https://img.youtube.com/vi/6VF6B6-WhHU/maxresdefault.jpg	https://www.youtube.com/watch?v=6VF6B6-WhHU	LGS	matematik	65	0	2026-01-23 06:10:09.407	SÜKRÜ AHMET	\N	t	0	2026-01-23 06:10:09.407	2026-01-23 06:10:35.814
\.


--
-- Data for Name: YearlySuccess; Type: TABLE DATA; Schema: public; Owner: hocalara_admin
--

COPY public."YearlySuccess" (id, year, "totalDegrees", "placementCount", "successRate", "cityCount", "top100Count", "top1000Count", "yksAverage", "lgsAverage", "isActive", "createdAt", "updatedAt", "branchId") FROM stdin;
49d8ee65-e01e-40ff-8e24-eff0b51f4d78	2024	156	1247	94.5	42	23	89	485.6	456.8	t	2026-01-22 14:53:04.631	2026-01-22 14:53:04.631	\N
ba0cc1eb-252c-4226-adea-14896ababe08	2023	142	1156	92.8	38	19	76	478.3	448.5	t	2026-01-22 14:53:04.643	2026-01-22 14:53:04.643	\N
a7b7e28a-6360-4262-a722-527072b6db6d	2022	128	1089	91.2	35	15	68	472.5	442.3	t	2026-01-22 14:53:04.648	2026-01-22 14:53:04.648	\N
1ef3fe23-1adf-4278-8182-f56efd2bba3e	3435	0	0	0	0	0	0	0	0	t	2026-01-22 14:58:42.498	2026-01-22 14:58:42.498	\N
c1c9f768-738f-4e65-933f-09c20b805d2b	2026	123	10	60	234	20	230	1230	220	t	2026-01-22 14:58:29.712	2026-01-23 05:45:23.47	\N
3fa03375-ecac-4b2a-ba6e-e767dcb90388	2026	0	0	0	0	0	0	0	0	t	2026-01-24 11:47:39.908	2026-01-24 11:47:39.908	38aeca3e-8805-44e8-a87f-d87acabc0033
b1a9d3be-91f0-40d2-86c2-d46b625244fd	2025	123	123	123	0	123	123	123	123	t	2026-01-26 08:15:18.771	2026-01-26 08:15:59.166	38aeca3e-8805-44e8-a87f-d87acabc0033
\.


--
-- Data for Name: YouTubeChannel; Type: TABLE DATA; Schema: public; Owner: hocalara_admin
--

COPY public."YouTubeChannel" (id, name, url, thumbnail, subscribers, "videoCount", description, "order", "isActive", "createdAt", "updatedAt") FROM stdin;
73cd1fb3-d6c8-4957-8696-eb45224c3d77	asdasdasd	https://www.youtube.com/watch?v=5TqPl3MSSow	\N	1	231	asdadas	0	t	2026-01-21 19:55:34.604	2026-01-21 19:55:34.604
\.


--
-- Data for Name: _prisma_migrations; Type: TABLE DATA; Schema: public; Owner: hocalara_admin
--

COPY public._prisma_migrations (id, checksum, finished_at, migration_name, logs, rolled_back_at, started_at, applied_steps_count) FROM stdin;
522e0d9c-6ee7-473f-8f9c-fff06be93b72	7691e060310c17163c951cbe8b31e5ccd6712ff1897a38d9128be491ceb830e7	2026-01-21 14:51:40.619655+00	20260120152540_initial_migration	\N	\N	2026-01-21 14:51:40.574304+00	1
9e1a8732-13cb-431f-bc76-8a5ef5a380c6	06f0f6c9be8f5877f8d897de16264739dcd49faf358a9f45d03ccace1d96621e	2026-01-21 14:51:40.642864+00	20260120185307_add_homepage_content_models	\N	\N	2026-01-21 14:51:40.62025+00	1
3e00627d-6ccb-46bc-ba5b-89d7738d33ee	eb89c3eea4a007b8457fc3a52905b741584bc49bfcba283be9c8db9e66c7bf48	2026-01-24 05:42:20.04882+00	20260124054220_add_blog_post_seo_fields	\N	\N	2026-01-24 05:42:20.044636+00	1
69dafdc2-ceca-40fa-8fbe-70ffea089ae7	d0f585188af074755bd2a04da87366263b75424ef082b9738c711fc40a33359c	2026-01-21 14:51:40.646066+00	20260120192420_add_youtube_channel_model	\N	\N	2026-01-21 14:51:40.643351+00	1
b4e6bf4d-b61c-4a29-8750-7db829c567e7	0552e76df77c7f4e9bc947e4120f38a8affa20499c3f578fd6321d0a75cf3c5e	2026-01-21 14:51:40.656574+00	20260120192934_add_yearly_success_models	\N	\N	2026-01-21 14:51:40.646455+00	1
84988cd6-be2c-471f-b454-3fdcce89c8e9	dec05db760fc08e0fdf09aaeab2a570e0dae954719fdaea90a1e27bfee8b194a	2026-01-24 20:21:04.150255+00	20260124202104_add_seo_to_home_section	\N	\N	2026-01-24 20:21:04.147535+00	1
c871a759-158c-434a-9bd1-30edaa8402c6	39ed41e11054cd0825de90bdd1dccf86df50efd02131433462853a411df5b97d	2026-01-21 14:51:40.668125+00	20260121015143_	\N	\N	2026-01-21 14:51:40.657017+00	1
3316aa24-76f8-405f-9832-501ee6201d48	033c091037544c556f450fdde1643e6ee73cd82b01be44456065437681a3824e	2026-01-24 06:49:19.854012+00	20260124064919_add_unique_slug_to_blog_post	\N	\N	2026-01-24 06:49:19.847038+00	1
ca9bfd7e-c59a-4798-894c-4bd31fbea5c8	47b75396901e1cf063db6e3793e4c54f2197adfbbd9e0abf313ca9ae19f47062	2026-01-21 15:37:49.926822+00	20260121153749_update_home_section_for_pages	\N	\N	2026-01-21 15:37:49.918741+00	1
65990e1a-63ad-4b0f-a1f9-7dd35557ce1d	01fbfa2e00f2de1a6e7a4a59fead43d5e152ff0b5ddb4c8d34960e3986c7f4bd	2026-01-21 18:05:22.063475+00	20260121180522_add_slider_text_styling	\N	\N	2026-01-21 18:05:22.057806+00	1
a02139c8-53e0-4499-b203-929a1da740c5	e0297ac7950093a56d6d68b661e661278be1426043fd96b64acd4ad5234c3578	2026-01-21 18:14:29.154141+00	20260121181429_add_slider_buttons	\N	\N	2026-01-21 18:14:29.150273+00	1
4be7d8f5-e694-4044-8911-20c899ad7977	22ff0ef9743aab9e43392c133b0e13865c256649a15602dc205288a0a921ed6b	2026-01-24 11:39:12.520138+00	20260124113912_add_branch_to_yearly_success	\N	\N	2026-01-24 11:39:12.50777+00	1
a1e7fc20-e4a9-4909-89f5-2809e7b0e6e1	4b11c3cbf8b46c1b13a5e87d55a82b5709e649fb99a5e251d5ab0b6a530eee56	2026-01-21 18:28:47.44065+00	20260121182847_add_banner_card_button_text	\N	\N	2026-01-21 18:28:47.438642+00	1
8fdca19e-54fe-40bb-a168-e65b1d3ae1a3	63cd59a313edb80ff94fde6274f642e6889723fea0d13790e9f4bd07b40b413a	2026-01-23 08:24:44.967668+00	20260123082444_add_approval_system	\N	\N	2026-01-23 08:24:44.948438+00	1
7cc4f637-3e12-4150-ad65-122c590d2f81	45eba1da0524c8caed5f35e67b16b43d0ea70970896cf84a4d26a36ff865f58a	2026-01-23 08:35:03.82803+00	20260123083503_add_notifications	\N	\N	2026-01-23 08:35:03.814259+00	1
4769af8f-8d5d-44bc-8a93-41a17d27cab1	a43a7d921342f1bd9146642da972edfaf4e2d195ad060a77e811003e8efa9f53	2026-01-24 11:59:03.614353+00	20260124115903_remove_unique_year_branch	\N	\N	2026-01-24 11:59:03.609673+00	1
aab51d30-4124-4371-bf99-fac7b19a1f5e	7c3cf57df8628aa372c7ad82480aeea0d4ba99868f3f18809da7cc4d89b9cb8d	2026-01-23 17:21:56.764591+00	20260123172156_add_packages_to_branch	\N	\N	2026-01-23 17:21:56.753215+00	1
af29efe4-4e69-4cc9-9908-a4ec685166c0	7e11a9ee83e3e17cb49f6312852a531f4a6c58d199c15831947d8c1887bb4a7e	2026-01-23 19:48:25.156866+00	20260123194825_add_blog_to_branch	\N	\N	2026-01-23 19:48:25.14747+00	1
4511cb88-cfa4-407a-98fc-c9866b43d87f	9566b13bd39344667deadc6bdd530de92adb04ea529d3afb5524664ce630636a	2026-01-26 06:18:00.836865+00	20260126061800_add_working_hours_to_branch	\N	\N	2026-01-26 06:18:00.831428+00	1
4bb38d54-fa6a-4c86-b950-7237091cc13e	2861db3e92e2a45c27013b4d41c2864a81eb4af7d6ec6fe3032404065c8d5386	2026-01-24 12:00:09.257023+00	20260124120009_add_back_unique_year_branch	\N	\N	2026-01-24 12:00:09.252239+00	1
0be619a9-8f5e-4bab-9cef-a1f6c61f41b3	d4a6af916d72aa57ea8cd3ccbfabc7bfc68876b33c4c2e4169775f7d49072bef	2026-01-24 12:39:45.046473+00	20260124123945_add_student_change_types	\N	\N	2026-01-24 12:39:45.044112+00	1
2ca7722b-39ac-41d2-8df9-3a9e32a83f94	7615cd6096d5927234d177c81174ff8937642535d417d63b9146aeb5c68403a7	2026-01-24 13:28:22.127556+00	20260124132822_add_lead_model	\N	\N	2026-01-24 13:28:22.115619+00	1
fda51bc6-b41e-4cbe-8d04-b9e28a0c6c2a	6cb55daffb1f121c0b2baa4cec0ee39b0a36f4cf50a63bc92d85d677c65ff9e5	2026-01-26 06:28:41.965239+00	20260126062841_add_features_to_branch	\N	\N	2026-01-26 06:28:41.962846+00	1
3e3ca001-3665-42f4-9d8c-e04a8d5ac398	945a0c9551fc0dc56c67bc50491008bb55753382e39416eb316cfb67e51a27b3	2026-01-24 16:27:41.353372+00	20260124162741_add_franchise_application_model	\N	\N	2026-01-24 16:27:41.34319+00	1
\.


--
-- Name: BannerCard BannerCard_pkey; Type: CONSTRAINT; Schema: public; Owner: hocalara_admin
--

ALTER TABLE ONLY public."BannerCard"
    ADD CONSTRAINT "BannerCard_pkey" PRIMARY KEY (id);


--
-- Name: BlogPost BlogPost_pkey; Type: CONSTRAINT; Schema: public; Owner: hocalara_admin
--

ALTER TABLE ONLY public."BlogPost"
    ADD CONSTRAINT "BlogPost_pkey" PRIMARY KEY (id);


--
-- Name: Branch Branch_pkey; Type: CONSTRAINT; Schema: public; Owner: hocalara_admin
--

ALTER TABLE ONLY public."Branch"
    ADD CONSTRAINT "Branch_pkey" PRIMARY KEY (id);


--
-- Name: Category Category_pkey; Type: CONSTRAINT; Schema: public; Owner: hocalara_admin
--

ALTER TABLE ONLY public."Category"
    ADD CONSTRAINT "Category_pkey" PRIMARY KEY (id);


--
-- Name: ChangeRequest ChangeRequest_pkey; Type: CONSTRAINT; Schema: public; Owner: hocalara_admin
--

ALTER TABLE ONLY public."ChangeRequest"
    ADD CONSTRAINT "ChangeRequest_pkey" PRIMARY KEY (id);


--
-- Name: ContactSubmission ContactSubmission_pkey; Type: CONSTRAINT; Schema: public; Owner: hocalara_admin
--

ALTER TABLE ONLY public."ContactSubmission"
    ADD CONSTRAINT "ContactSubmission_pkey" PRIMARY KEY (id);


--
-- Name: EducationPackage EducationPackage_pkey; Type: CONSTRAINT; Schema: public; Owner: hocalara_admin
--

ALTER TABLE ONLY public."EducationPackage"
    ADD CONSTRAINT "EducationPackage_pkey" PRIMARY KEY (id);


--
-- Name: ExamDate ExamDate_pkey; Type: CONSTRAINT; Schema: public; Owner: hocalara_admin
--

ALTER TABLE ONLY public."ExamDate"
    ADD CONSTRAINT "ExamDate_pkey" PRIMARY KEY (id);


--
-- Name: Feature Feature_pkey; Type: CONSTRAINT; Schema: public; Owner: hocalara_admin
--

ALTER TABLE ONLY public."Feature"
    ADD CONSTRAINT "Feature_pkey" PRIMARY KEY (id);


--
-- Name: FranchiseApplication FranchiseApplication_pkey; Type: CONSTRAINT; Schema: public; Owner: hocalara_admin
--

ALTER TABLE ONLY public."FranchiseApplication"
    ADD CONSTRAINT "FranchiseApplication_pkey" PRIMARY KEY (id);


--
-- Name: HomeSection HomeSection_pkey; Type: CONSTRAINT; Schema: public; Owner: hocalara_admin
--

ALTER TABLE ONLY public."HomeSection"
    ADD CONSTRAINT "HomeSection_pkey" PRIMARY KEY (id);


--
-- Name: Lead Lead_pkey; Type: CONSTRAINT; Schema: public; Owner: hocalara_admin
--

ALTER TABLE ONLY public."Lead"
    ADD CONSTRAINT "Lead_pkey" PRIMARY KEY (id);


--
-- Name: Media Media_pkey; Type: CONSTRAINT; Schema: public; Owner: hocalara_admin
--

ALTER TABLE ONLY public."Media"
    ADD CONSTRAINT "Media_pkey" PRIMARY KEY (id);


--
-- Name: MenuItem MenuItem_pkey; Type: CONSTRAINT; Schema: public; Owner: hocalara_admin
--

ALTER TABLE ONLY public."MenuItem"
    ADD CONSTRAINT "MenuItem_pkey" PRIMARY KEY (id);


--
-- Name: Menu Menu_pkey; Type: CONSTRAINT; Schema: public; Owner: hocalara_admin
--

ALTER TABLE ONLY public."Menu"
    ADD CONSTRAINT "Menu_pkey" PRIMARY KEY (id);


--
-- Name: Notification Notification_pkey; Type: CONSTRAINT; Schema: public; Owner: hocalara_admin
--

ALTER TABLE ONLY public."Notification"
    ADD CONSTRAINT "Notification_pkey" PRIMARY KEY (id);


--
-- Name: Page Page_pkey; Type: CONSTRAINT; Schema: public; Owner: hocalara_admin
--

ALTER TABLE ONLY public."Page"
    ADD CONSTRAINT "Page_pkey" PRIMARY KEY (id);


--
-- Name: Setting Setting_pkey; Type: CONSTRAINT; Schema: public; Owner: hocalara_admin
--

ALTER TABLE ONLY public."Setting"
    ADD CONSTRAINT "Setting_pkey" PRIMARY KEY (id);


--
-- Name: Slider Slider_pkey; Type: CONSTRAINT; Schema: public; Owner: hocalara_admin
--

ALTER TABLE ONLY public."Slider"
    ADD CONSTRAINT "Slider_pkey" PRIMARY KEY (id);


--
-- Name: SocialMedia SocialMedia_pkey; Type: CONSTRAINT; Schema: public; Owner: hocalara_admin
--

ALTER TABLE ONLY public."SocialMedia"
    ADD CONSTRAINT "SocialMedia_pkey" PRIMARY KEY (id);


--
-- Name: Statistic Statistic_pkey; Type: CONSTRAINT; Schema: public; Owner: hocalara_admin
--

ALTER TABLE ONLY public."Statistic"
    ADD CONSTRAINT "Statistic_pkey" PRIMARY KEY (id);


--
-- Name: SuccessBanner SuccessBanner_pkey; Type: CONSTRAINT; Schema: public; Owner: hocalara_admin
--

ALTER TABLE ONLY public."SuccessBanner"
    ADD CONSTRAINT "SuccessBanner_pkey" PRIMARY KEY (id);


--
-- Name: Teacher Teacher_pkey; Type: CONSTRAINT; Schema: public; Owner: hocalara_admin
--

ALTER TABLE ONLY public."Teacher"
    ADD CONSTRAINT "Teacher_pkey" PRIMARY KEY (id);


--
-- Name: TopStudent TopStudent_pkey; Type: CONSTRAINT; Schema: public; Owner: hocalara_admin
--

ALTER TABLE ONLY public."TopStudent"
    ADD CONSTRAINT "TopStudent_pkey" PRIMARY KEY (id);


--
-- Name: User User_pkey; Type: CONSTRAINT; Schema: public; Owner: hocalara_admin
--

ALTER TABLE ONLY public."User"
    ADD CONSTRAINT "User_pkey" PRIMARY KEY (id);


--
-- Name: VideoLesson VideoLesson_pkey; Type: CONSTRAINT; Schema: public; Owner: hocalara_admin
--

ALTER TABLE ONLY public."VideoLesson"
    ADD CONSTRAINT "VideoLesson_pkey" PRIMARY KEY (id);


--
-- Name: YearlySuccess YearlySuccess_pkey; Type: CONSTRAINT; Schema: public; Owner: hocalara_admin
--

ALTER TABLE ONLY public."YearlySuccess"
    ADD CONSTRAINT "YearlySuccess_pkey" PRIMARY KEY (id);


--
-- Name: YouTubeChannel YouTubeChannel_pkey; Type: CONSTRAINT; Schema: public; Owner: hocalara_admin
--

ALTER TABLE ONLY public."YouTubeChannel"
    ADD CONSTRAINT "YouTubeChannel_pkey" PRIMARY KEY (id);


--
-- Name: _prisma_migrations _prisma_migrations_pkey; Type: CONSTRAINT; Schema: public; Owner: hocalara_admin
--

ALTER TABLE ONLY public._prisma_migrations
    ADD CONSTRAINT _prisma_migrations_pkey PRIMARY KEY (id);


--
-- Name: BannerCard_isActive_idx; Type: INDEX; Schema: public; Owner: hocalara_admin
--

CREATE INDEX "BannerCard_isActive_idx" ON public."BannerCard" USING btree ("isActive");


--
-- Name: BannerCard_order_idx; Type: INDEX; Schema: public; Owner: hocalara_admin
--

CREATE INDEX "BannerCard_order_idx" ON public."BannerCard" USING btree ("order");


--
-- Name: BlogPost_branchId_idx; Type: INDEX; Schema: public; Owner: hocalara_admin
--

CREATE INDEX "BlogPost_branchId_idx" ON public."BlogPost" USING btree ("branchId");


--
-- Name: BlogPost_category_idx; Type: INDEX; Schema: public; Owner: hocalara_admin
--

CREATE INDEX "BlogPost_category_idx" ON public."BlogPost" USING btree (category);


--
-- Name: BlogPost_isActive_idx; Type: INDEX; Schema: public; Owner: hocalara_admin
--

CREATE INDEX "BlogPost_isActive_idx" ON public."BlogPost" USING btree ("isActive");


--
-- Name: BlogPost_slug_key; Type: INDEX; Schema: public; Owner: hocalara_admin
--

CREATE UNIQUE INDEX "BlogPost_slug_key" ON public."BlogPost" USING btree (slug);


--
-- Name: Branch_isActive_idx; Type: INDEX; Schema: public; Owner: hocalara_admin
--

CREATE INDEX "Branch_isActive_idx" ON public."Branch" USING btree ("isActive");


--
-- Name: Branch_slug_idx; Type: INDEX; Schema: public; Owner: hocalara_admin
--

CREATE INDEX "Branch_slug_idx" ON public."Branch" USING btree (slug);


--
-- Name: Branch_slug_key; Type: INDEX; Schema: public; Owner: hocalara_admin
--

CREATE UNIQUE INDEX "Branch_slug_key" ON public."Branch" USING btree (slug);


--
-- Name: Category_order_idx; Type: INDEX; Schema: public; Owner: hocalara_admin
--

CREATE INDEX "Category_order_idx" ON public."Category" USING btree ("order");


--
-- Name: Category_parentId_idx; Type: INDEX; Schema: public; Owner: hocalara_admin
--

CREATE INDEX "Category_parentId_idx" ON public."Category" USING btree ("parentId");


--
-- Name: Category_slug_idx; Type: INDEX; Schema: public; Owner: hocalara_admin
--

CREATE INDEX "Category_slug_idx" ON public."Category" USING btree (slug);


--
-- Name: Category_slug_key; Type: INDEX; Schema: public; Owner: hocalara_admin
--

CREATE UNIQUE INDEX "Category_slug_key" ON public."Category" USING btree (slug);


--
-- Name: ChangeRequest_branchId_idx; Type: INDEX; Schema: public; Owner: hocalara_admin
--

CREATE INDEX "ChangeRequest_branchId_idx" ON public."ChangeRequest" USING btree ("branchId");


--
-- Name: ChangeRequest_changeType_idx; Type: INDEX; Schema: public; Owner: hocalara_admin
--

CREATE INDEX "ChangeRequest_changeType_idx" ON public."ChangeRequest" USING btree ("changeType");


--
-- Name: ChangeRequest_requestedBy_idx; Type: INDEX; Schema: public; Owner: hocalara_admin
--

CREATE INDEX "ChangeRequest_requestedBy_idx" ON public."ChangeRequest" USING btree ("requestedBy");


--
-- Name: ChangeRequest_status_idx; Type: INDEX; Schema: public; Owner: hocalara_admin
--

CREATE INDEX "ChangeRequest_status_idx" ON public."ChangeRequest" USING btree (status);


--
-- Name: ContactSubmission_branchId_idx; Type: INDEX; Schema: public; Owner: hocalara_admin
--

CREATE INDEX "ContactSubmission_branchId_idx" ON public."ContactSubmission" USING btree ("branchId");


--
-- Name: ContactSubmission_createdAt_idx; Type: INDEX; Schema: public; Owner: hocalara_admin
--

CREATE INDEX "ContactSubmission_createdAt_idx" ON public."ContactSubmission" USING btree ("createdAt");


--
-- Name: ContactSubmission_isRead_idx; Type: INDEX; Schema: public; Owner: hocalara_admin
--

CREATE INDEX "ContactSubmission_isRead_idx" ON public."ContactSubmission" USING btree ("isRead");


--
-- Name: EducationPackage_branchId_idx; Type: INDEX; Schema: public; Owner: hocalara_admin
--

CREATE INDEX "EducationPackage_branchId_idx" ON public."EducationPackage" USING btree ("branchId");


--
-- Name: EducationPackage_slug_key; Type: INDEX; Schema: public; Owner: hocalara_admin
--

CREATE UNIQUE INDEX "EducationPackage_slug_key" ON public."EducationPackage" USING btree (slug);


--
-- Name: ExamDate_examDate_idx; Type: INDEX; Schema: public; Owner: hocalara_admin
--

CREATE INDEX "ExamDate_examDate_idx" ON public."ExamDate" USING btree ("examDate");


--
-- Name: ExamDate_isActive_idx; Type: INDEX; Schema: public; Owner: hocalara_admin
--

CREATE INDEX "ExamDate_isActive_idx" ON public."ExamDate" USING btree ("isActive");


--
-- Name: ExamDate_order_idx; Type: INDEX; Schema: public; Owner: hocalara_admin
--

CREATE INDEX "ExamDate_order_idx" ON public."ExamDate" USING btree ("order");


--
-- Name: Feature_isActive_idx; Type: INDEX; Schema: public; Owner: hocalara_admin
--

CREATE INDEX "Feature_isActive_idx" ON public."Feature" USING btree ("isActive");


--
-- Name: Feature_order_idx; Type: INDEX; Schema: public; Owner: hocalara_admin
--

CREATE INDEX "Feature_order_idx" ON public."Feature" USING btree ("order");


--
-- Name: Feature_section_idx; Type: INDEX; Schema: public; Owner: hocalara_admin
--

CREATE INDEX "Feature_section_idx" ON public."Feature" USING btree (section);


--
-- Name: FranchiseApplication_createdAt_idx; Type: INDEX; Schema: public; Owner: hocalara_admin
--

CREATE INDEX "FranchiseApplication_createdAt_idx" ON public."FranchiseApplication" USING btree ("createdAt");


--
-- Name: FranchiseApplication_status_idx; Type: INDEX; Schema: public; Owner: hocalara_admin
--

CREATE INDEX "FranchiseApplication_status_idx" ON public."FranchiseApplication" USING btree (status);


--
-- Name: HomeSection_page_idx; Type: INDEX; Schema: public; Owner: hocalara_admin
--

CREATE INDEX "HomeSection_page_idx" ON public."HomeSection" USING btree (page);


--
-- Name: HomeSection_page_section_key; Type: INDEX; Schema: public; Owner: hocalara_admin
--

CREATE UNIQUE INDEX "HomeSection_page_section_key" ON public."HomeSection" USING btree (page, section);


--
-- Name: HomeSection_section_idx; Type: INDEX; Schema: public; Owner: hocalara_admin
--

CREATE INDEX "HomeSection_section_idx" ON public."HomeSection" USING btree (section);


--
-- Name: Lead_branchId_idx; Type: INDEX; Schema: public; Owner: hocalara_admin
--

CREATE INDEX "Lead_branchId_idx" ON public."Lead" USING btree ("branchId");


--
-- Name: Media_pageId_idx; Type: INDEX; Schema: public; Owner: hocalara_admin
--

CREATE INDEX "Media_pageId_idx" ON public."Media" USING btree ("pageId");


--
-- Name: Media_type_idx; Type: INDEX; Schema: public; Owner: hocalara_admin
--

CREATE INDEX "Media_type_idx" ON public."Media" USING btree (type);


--
-- Name: MenuItem_menuId_idx; Type: INDEX; Schema: public; Owner: hocalara_admin
--

CREATE INDEX "MenuItem_menuId_idx" ON public."MenuItem" USING btree ("menuId");


--
-- Name: MenuItem_order_idx; Type: INDEX; Schema: public; Owner: hocalara_admin
--

CREATE INDEX "MenuItem_order_idx" ON public."MenuItem" USING btree ("order");


--
-- Name: MenuItem_parentId_idx; Type: INDEX; Schema: public; Owner: hocalara_admin
--

CREATE INDEX "MenuItem_parentId_idx" ON public."MenuItem" USING btree ("parentId");


--
-- Name: Menu_position_idx; Type: INDEX; Schema: public; Owner: hocalara_admin
--

CREATE INDEX "Menu_position_idx" ON public."Menu" USING btree ("position");


--
-- Name: Menu_slug_idx; Type: INDEX; Schema: public; Owner: hocalara_admin
--

CREATE INDEX "Menu_slug_idx" ON public."Menu" USING btree (slug);


--
-- Name: Menu_slug_key; Type: INDEX; Schema: public; Owner: hocalara_admin
--

CREATE UNIQUE INDEX "Menu_slug_key" ON public."Menu" USING btree (slug);


--
-- Name: Notification_createdAt_idx; Type: INDEX; Schema: public; Owner: hocalara_admin
--

CREATE INDEX "Notification_createdAt_idx" ON public."Notification" USING btree ("createdAt");


--
-- Name: Notification_isRead_idx; Type: INDEX; Schema: public; Owner: hocalara_admin
--

CREATE INDEX "Notification_isRead_idx" ON public."Notification" USING btree ("isRead");


--
-- Name: Notification_userId_idx; Type: INDEX; Schema: public; Owner: hocalara_admin
--

CREATE INDEX "Notification_userId_idx" ON public."Notification" USING btree ("userId");


--
-- Name: Page_branchId_idx; Type: INDEX; Schema: public; Owner: hocalara_admin
--

CREATE INDEX "Page_branchId_idx" ON public."Page" USING btree ("branchId");


--
-- Name: Page_categoryId_idx; Type: INDEX; Schema: public; Owner: hocalara_admin
--

CREATE INDEX "Page_categoryId_idx" ON public."Page" USING btree ("categoryId");


--
-- Name: Page_isApproved_idx; Type: INDEX; Schema: public; Owner: hocalara_admin
--

CREATE INDEX "Page_isApproved_idx" ON public."Page" USING btree ("isApproved");


--
-- Name: Page_publishedAt_idx; Type: INDEX; Schema: public; Owner: hocalara_admin
--

CREATE INDEX "Page_publishedAt_idx" ON public."Page" USING btree ("publishedAt");


--
-- Name: Page_slug_idx; Type: INDEX; Schema: public; Owner: hocalara_admin
--

CREATE INDEX "Page_slug_idx" ON public."Page" USING btree (slug);


--
-- Name: Page_slug_key; Type: INDEX; Schema: public; Owner: hocalara_admin
--

CREATE UNIQUE INDEX "Page_slug_key" ON public."Page" USING btree (slug);


--
-- Name: Page_status_idx; Type: INDEX; Schema: public; Owner: hocalara_admin
--

CREATE INDEX "Page_status_idx" ON public."Page" USING btree (status);


--
-- Name: Page_type_idx; Type: INDEX; Schema: public; Owner: hocalara_admin
--

CREATE INDEX "Page_type_idx" ON public."Page" USING btree (type);


--
-- Name: Setting_group_idx; Type: INDEX; Schema: public; Owner: hocalara_admin
--

CREATE INDEX "Setting_group_idx" ON public."Setting" USING btree ("group");


--
-- Name: Setting_key_idx; Type: INDEX; Schema: public; Owner: hocalara_admin
--

CREATE INDEX "Setting_key_idx" ON public."Setting" USING btree (key);


--
-- Name: Setting_key_key; Type: INDEX; Schema: public; Owner: hocalara_admin
--

CREATE UNIQUE INDEX "Setting_key_key" ON public."Setting" USING btree (key);


--
-- Name: Slider_isActive_idx; Type: INDEX; Schema: public; Owner: hocalara_admin
--

CREATE INDEX "Slider_isActive_idx" ON public."Slider" USING btree ("isActive");


--
-- Name: Slider_order_idx; Type: INDEX; Schema: public; Owner: hocalara_admin
--

CREATE INDEX "Slider_order_idx" ON public."Slider" USING btree ("order");


--
-- Name: Slider_target_idx; Type: INDEX; Schema: public; Owner: hocalara_admin
--

CREATE INDEX "Slider_target_idx" ON public."Slider" USING btree (target);


--
-- Name: SocialMedia_isActive_idx; Type: INDEX; Schema: public; Owner: hocalara_admin
--

CREATE INDEX "SocialMedia_isActive_idx" ON public."SocialMedia" USING btree ("isActive");


--
-- Name: SocialMedia_order_idx; Type: INDEX; Schema: public; Owner: hocalara_admin
--

CREATE INDEX "SocialMedia_order_idx" ON public."SocialMedia" USING btree ("order");


--
-- Name: SocialMedia_platform_idx; Type: INDEX; Schema: public; Owner: hocalara_admin
--

CREATE INDEX "SocialMedia_platform_idx" ON public."SocialMedia" USING btree (platform);


--
-- Name: Statistic_isActive_idx; Type: INDEX; Schema: public; Owner: hocalara_admin
--

CREATE INDEX "Statistic_isActive_idx" ON public."Statistic" USING btree ("isActive");


--
-- Name: Statistic_order_idx; Type: INDEX; Schema: public; Owner: hocalara_admin
--

CREATE INDEX "Statistic_order_idx" ON public."Statistic" USING btree ("order");


--
-- Name: SuccessBanner_yearlySuccessId_key; Type: INDEX; Schema: public; Owner: hocalara_admin
--

CREATE UNIQUE INDEX "SuccessBanner_yearlySuccessId_key" ON public."SuccessBanner" USING btree ("yearlySuccessId");


--
-- Name: Teacher_branchId_idx; Type: INDEX; Schema: public; Owner: hocalara_admin
--

CREATE INDEX "Teacher_branchId_idx" ON public."Teacher" USING btree ("branchId");


--
-- Name: User_branchId_idx; Type: INDEX; Schema: public; Owner: hocalara_admin
--

CREATE INDEX "User_branchId_idx" ON public."User" USING btree ("branchId");


--
-- Name: User_email_idx; Type: INDEX; Schema: public; Owner: hocalara_admin
--

CREATE INDEX "User_email_idx" ON public."User" USING btree (email);


--
-- Name: User_email_key; Type: INDEX; Schema: public; Owner: hocalara_admin
--

CREATE UNIQUE INDEX "User_email_key" ON public."User" USING btree (email);


--
-- Name: User_role_idx; Type: INDEX; Schema: public; Owner: hocalara_admin
--

CREATE INDEX "User_role_idx" ON public."User" USING btree (role);


--
-- Name: YearlySuccess_branchId_idx; Type: INDEX; Schema: public; Owner: hocalara_admin
--

CREATE INDEX "YearlySuccess_branchId_idx" ON public."YearlySuccess" USING btree ("branchId");


--
-- Name: YearlySuccess_year_branchId_key; Type: INDEX; Schema: public; Owner: hocalara_admin
--

CREATE UNIQUE INDEX "YearlySuccess_year_branchId_key" ON public."YearlySuccess" USING btree (year, "branchId");


--
-- Name: YearlySuccess_year_idx; Type: INDEX; Schema: public; Owner: hocalara_admin
--

CREATE INDEX "YearlySuccess_year_idx" ON public."YearlySuccess" USING btree (year);


--
-- Name: BlogPost BlogPost_branchId_fkey; Type: FK CONSTRAINT; Schema: public; Owner: hocalara_admin
--

ALTER TABLE ONLY public."BlogPost"
    ADD CONSTRAINT "BlogPost_branchId_fkey" FOREIGN KEY ("branchId") REFERENCES public."Branch"(id) ON UPDATE CASCADE ON DELETE SET NULL;


--
-- Name: Category Category_parentId_fkey; Type: FK CONSTRAINT; Schema: public; Owner: hocalara_admin
--

ALTER TABLE ONLY public."Category"
    ADD CONSTRAINT "Category_parentId_fkey" FOREIGN KEY ("parentId") REFERENCES public."Category"(id) ON UPDATE CASCADE ON DELETE SET NULL;


--
-- Name: ChangeRequest ChangeRequest_branchId_fkey; Type: FK CONSTRAINT; Schema: public; Owner: hocalara_admin
--

ALTER TABLE ONLY public."ChangeRequest"
    ADD CONSTRAINT "ChangeRequest_branchId_fkey" FOREIGN KEY ("branchId") REFERENCES public."Branch"(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: ChangeRequest ChangeRequest_requestedBy_fkey; Type: FK CONSTRAINT; Schema: public; Owner: hocalara_admin
--

ALTER TABLE ONLY public."ChangeRequest"
    ADD CONSTRAINT "ChangeRequest_requestedBy_fkey" FOREIGN KEY ("requestedBy") REFERENCES public."User"(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: ChangeRequest ChangeRequest_reviewedBy_fkey; Type: FK CONSTRAINT; Schema: public; Owner: hocalara_admin
--

ALTER TABLE ONLY public."ChangeRequest"
    ADD CONSTRAINT "ChangeRequest_reviewedBy_fkey" FOREIGN KEY ("reviewedBy") REFERENCES public."User"(id) ON UPDATE CASCADE ON DELETE SET NULL;


--
-- Name: EducationPackage EducationPackage_branchId_fkey; Type: FK CONSTRAINT; Schema: public; Owner: hocalara_admin
--

ALTER TABLE ONLY public."EducationPackage"
    ADD CONSTRAINT "EducationPackage_branchId_fkey" FOREIGN KEY ("branchId") REFERENCES public."Branch"(id) ON UPDATE CASCADE ON DELETE SET NULL;


--
-- Name: Lead Lead_branchId_fkey; Type: FK CONSTRAINT; Schema: public; Owner: hocalara_admin
--

ALTER TABLE ONLY public."Lead"
    ADD CONSTRAINT "Lead_branchId_fkey" FOREIGN KEY ("branchId") REFERENCES public."Branch"(id) ON UPDATE CASCADE ON DELETE SET NULL;


--
-- Name: Media Media_pageId_fkey; Type: FK CONSTRAINT; Schema: public; Owner: hocalara_admin
--

ALTER TABLE ONLY public."Media"
    ADD CONSTRAINT "Media_pageId_fkey" FOREIGN KEY ("pageId") REFERENCES public."Page"(id) ON UPDATE CASCADE ON DELETE SET NULL;


--
-- Name: MenuItem MenuItem_categoryId_fkey; Type: FK CONSTRAINT; Schema: public; Owner: hocalara_admin
--

ALTER TABLE ONLY public."MenuItem"
    ADD CONSTRAINT "MenuItem_categoryId_fkey" FOREIGN KEY ("categoryId") REFERENCES public."Category"(id) ON UPDATE CASCADE ON DELETE SET NULL;


--
-- Name: MenuItem MenuItem_menuId_fkey; Type: FK CONSTRAINT; Schema: public; Owner: hocalara_admin
--

ALTER TABLE ONLY public."MenuItem"
    ADD CONSTRAINT "MenuItem_menuId_fkey" FOREIGN KEY ("menuId") REFERENCES public."Menu"(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: MenuItem MenuItem_pageId_fkey; Type: FK CONSTRAINT; Schema: public; Owner: hocalara_admin
--

ALTER TABLE ONLY public."MenuItem"
    ADD CONSTRAINT "MenuItem_pageId_fkey" FOREIGN KEY ("pageId") REFERENCES public."Page"(id) ON UPDATE CASCADE ON DELETE SET NULL;


--
-- Name: MenuItem MenuItem_parentId_fkey; Type: FK CONSTRAINT; Schema: public; Owner: hocalara_admin
--

ALTER TABLE ONLY public."MenuItem"
    ADD CONSTRAINT "MenuItem_parentId_fkey" FOREIGN KEY ("parentId") REFERENCES public."MenuItem"(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: Menu Menu_createdById_fkey; Type: FK CONSTRAINT; Schema: public; Owner: hocalara_admin
--

ALTER TABLE ONLY public."Menu"
    ADD CONSTRAINT "Menu_createdById_fkey" FOREIGN KEY ("createdById") REFERENCES public."User"(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: Notification Notification_changeRequestId_fkey; Type: FK CONSTRAINT; Schema: public; Owner: hocalara_admin
--

ALTER TABLE ONLY public."Notification"
    ADD CONSTRAINT "Notification_changeRequestId_fkey" FOREIGN KEY ("changeRequestId") REFERENCES public."ChangeRequest"(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: Notification Notification_userId_fkey; Type: FK CONSTRAINT; Schema: public; Owner: hocalara_admin
--

ALTER TABLE ONLY public."Notification"
    ADD CONSTRAINT "Notification_userId_fkey" FOREIGN KEY ("userId") REFERENCES public."User"(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: Page Page_authorId_fkey; Type: FK CONSTRAINT; Schema: public; Owner: hocalara_admin
--

ALTER TABLE ONLY public."Page"
    ADD CONSTRAINT "Page_authorId_fkey" FOREIGN KEY ("authorId") REFERENCES public."User"(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: Page Page_branchId_fkey; Type: FK CONSTRAINT; Schema: public; Owner: hocalara_admin
--

ALTER TABLE ONLY public."Page"
    ADD CONSTRAINT "Page_branchId_fkey" FOREIGN KEY ("branchId") REFERENCES public."Branch"(id) ON UPDATE CASCADE ON DELETE SET NULL;


--
-- Name: Page Page_categoryId_fkey; Type: FK CONSTRAINT; Schema: public; Owner: hocalara_admin
--

ALTER TABLE ONLY public."Page"
    ADD CONSTRAINT "Page_categoryId_fkey" FOREIGN KEY ("categoryId") REFERENCES public."Category"(id) ON UPDATE CASCADE ON DELETE SET NULL;


--
-- Name: Slider Slider_createdById_fkey; Type: FK CONSTRAINT; Schema: public; Owner: hocalara_admin
--

ALTER TABLE ONLY public."Slider"
    ADD CONSTRAINT "Slider_createdById_fkey" FOREIGN KEY ("createdById") REFERENCES public."User"(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: SuccessBanner SuccessBanner_yearlySuccessId_fkey; Type: FK CONSTRAINT; Schema: public; Owner: hocalara_admin
--

ALTER TABLE ONLY public."SuccessBanner"
    ADD CONSTRAINT "SuccessBanner_yearlySuccessId_fkey" FOREIGN KEY ("yearlySuccessId") REFERENCES public."YearlySuccess"(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: Teacher Teacher_branchId_fkey; Type: FK CONSTRAINT; Schema: public; Owner: hocalara_admin
--

ALTER TABLE ONLY public."Teacher"
    ADD CONSTRAINT "Teacher_branchId_fkey" FOREIGN KEY ("branchId") REFERENCES public."Branch"(id) ON UPDATE CASCADE ON DELETE SET NULL;


--
-- Name: TopStudent TopStudent_yearlySuccessId_fkey; Type: FK CONSTRAINT; Schema: public; Owner: hocalara_admin
--

ALTER TABLE ONLY public."TopStudent"
    ADD CONSTRAINT "TopStudent_yearlySuccessId_fkey" FOREIGN KEY ("yearlySuccessId") REFERENCES public."YearlySuccess"(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: User User_branchId_fkey; Type: FK CONSTRAINT; Schema: public; Owner: hocalara_admin
--

ALTER TABLE ONLY public."User"
    ADD CONSTRAINT "User_branchId_fkey" FOREIGN KEY ("branchId") REFERENCES public."Branch"(id) ON UPDATE CASCADE ON DELETE SET NULL;


--
-- Name: YearlySuccess YearlySuccess_branchId_fkey; Type: FK CONSTRAINT; Schema: public; Owner: hocalara_admin
--

ALTER TABLE ONLY public."YearlySuccess"
    ADD CONSTRAINT "YearlySuccess_branchId_fkey" FOREIGN KEY ("branchId") REFERENCES public."Branch"(id) ON UPDATE CASCADE ON DELETE SET NULL;


--
-- PostgreSQL database dump complete
--

\unrestrict HM3KtysWLijlhJvKMpnE18vjrPRPR6Sg71gnICHongDq9FIXxBAelxlMYGblxSF

