<script lang="ts">
  import { page } from '$app/stores';
  import { faker } from '@faker-js/faker';
  import type { HighlightMetadata } from '@highlighter/ui-mobile';
  import {
    HighlightsFollowingBanner,
    HighlightsFollowingList,
    Navbar
  } from '@highlighter/ui-mobile';
  import { DateTime } from 'luxon';

  const randomDateCreatedWithin400Days = (): number => {
    const timeDelta = Math.floor(Math.random() * 500) + 1;
    if (Math.random() < 0.5) {
      return DateTime.now().minus({ days: timeDelta }).toMillis();
    } else {
      return DateTime.now().minus({ seconds: timeDelta }).toMillis();
    }
  };

  let bannerHighlights = Array.from({ length: 10 }).map(
    (_): HighlightMetadata => ({
      id: faker.string.alphanumeric(8),
      author: faker.internet.userName(),
      dateCreated: randomDateCreatedWithin400Days(),
      title: faker.lorem.sentence(22),
      preview: faker.lorem.sentence(18),
      stars: faker.number.int(5),
      zaps: faker.number.int(10000),
      marginNotes: faker.lorem.sentence({ min: 20, max: 56 })
    })
  );

  let listHighlights = Array.from({ length: 10 }).map(
    (_): HighlightMetadata => ({
      id: faker.string.alphanumeric(8),
      author: faker.internet.userName(),
      dateCreated: randomDateCreatedWithin400Days(),
      title: faker.lorem.sentence(3),
      preview: faker.lorem.sentence({ min: 12, max: 48 }),
      stars: faker.number.int(5),
      zaps: faker.number.int(10000),
      marginNotes: faker.lorem.sentence({ min: 20, max: 56 }),
      commentsList: Array.from({ length: 4 }).map((_) => ({ author: faker.internet.displayName() }))
    })
  );
</script>

<div class="flex flex-col w-full justify-center items-center space-y-6">
  <Navbar pathname={$page.url.pathname} />
  <HighlightsFollowingBanner list={bannerHighlights} />
  <HighlightsFollowingList list={listHighlights} />
</div>
