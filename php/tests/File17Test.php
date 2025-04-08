<?php
use PHPUnit\Framework\TestCase;
use Demo\File17;

class File17Test extends TestCase {
    public function testAdd() {
        $this->assertEquals(5, File17::add(2, 3));
    }
}
